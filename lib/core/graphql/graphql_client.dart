import 'dart:convert';
import 'package:graphql/client.dart' hide ServerException;
import '../../services/storage_service.dart';
import '../constants/api_endpoints.dart';
import '../errors/exceptions.dart';

/// Link that injects Authorization Bearer token and multi-tenant prefix header into GraphQL requests.
class AuthAndTenantLink extends Link {
  final StorageService storage;

  AuthAndTenantLink(this.storage);

  @override
  Stream<Response> request(
    Request request, [
    NextLink? forward,
  ]) async* {
    final token = await storage.getToken();
    var req = request;

    if (token != null && token.isNotEmpty) {
      final prefix = _extractPrefix(token);
      req = request.updateContextEntry<HttpLinkHeaders>(
        (headers) => HttpLinkHeaders(
          headers: <String, String>{
            ...headers?.headers ?? <String, String>{},
            'Authorization': 'Bearer $token',
            if (prefix != null && prefix.isNotEmpty) 'prefix': prefix,
          },
        ),
      );
    }

    yield* forward!(req);
  }

  static String? _extractPrefix(String token) {
    try {
      final parts = token.split('.');
      if (parts.length >= 2) {
        final normalized = base64Url.normalize(parts[1]);
        final decoded = utf8.decode(base64Url.decode(normalized));
        final map = jsonDecode(decoded);
        if (map is Map<String, dynamic>) {
          return map['prefix'] as String?;
        }
      }
    } catch (_) {}
    return null;
  }
}

/// Centralized pure Dart GraphQL client wrapper using `package:graphql/client.dart`.
class AppGraphQLClient {
  static GraphQLClient? _client;

  /// Returns configured [GraphQLClient] instance with Auth and Error links.
  static Future<GraphQLClient> getClient({StorageService? storageService}) async {
    final storage = storageService ?? await StorageService.getInstance();
    final customUrl = storage.getString(StorageService.keyApiBaseUrl);
    if (customUrl != null && customUrl.isNotEmpty) {
      ApiEndpoints.setBaseUrl(customUrl);
    }

    if (_client != null) return _client!;

    final httpLink = HttpLink(ApiEndpoints.graphqlUrl);

    final authAndTenantLink = AuthAndTenantLink(storage);

    final errorLink = ErrorLink(
      onGraphQLError: (request, forward, response) {
        for (final error in response.errors ?? <GraphQLError>[]) {
          final msg = error.message.toLowerCase();
          if (msg.contains('unauthorized') || msg.contains('unauthenticated')) {
            storage.deleteToken();
          }
        }
        return forward(request);
      },
      onException: (request, forward, exception) {
        return forward(request);
      },
    );

    final link = Link.from([errorLink, authAndTenantLink, httpLink]);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    return _client!;
  }

  /// Resets client (useful when environment URL changes or user logs out).
  static void resetClient() {
    _client = null;
  }

  /// Verifies API connectivity with an unauthenticated query.
  static Future<bool> verifyConnectivity({GraphQLClient? client}) async {
    try {
      final activeClient = client ?? await getClient();
      final result = await activeClient.query(
        QueryOptions(
          document: gql(r'query CheckConnectivity { __typename }'),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw ServerException(
          result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : (result.exception?.linkException?.toString() ?? 'GraphQL connection failed'),
        );
      }

      final data = result.data;
      return data != null && data['__typename'] != null;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to connect to ${ApiEndpoints.graphqlUrl}: $e');
    }
  }
}
