import '../constants/api_endpoints.dart';
import '../network/api_client.dart';

/// Lightweight GraphQL client wrapper.
class GraphQLClient {
  final ApiClient _apiClient;
  final String endpoint;

  GraphQLClient({
    ApiClient? apiClient,
    this.endpoint = ApiEndpoints.graphqlUrl,
  }) : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> query({
    required String query,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
  }) async {
    final body = <String, dynamic>{
      'query': query,
    };
    if (variables != null) {
      body['variables'] = variables;
    }

    final response = await _apiClient.post(
      endpoint,
      headers: headers,
      body: body,
    );
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> mutate({
    required String mutation,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
  }) async {
    return query(
      query: mutation,
      variables: variables,
      headers: headers,
    );
  }
}
