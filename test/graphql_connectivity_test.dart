import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/core/graphql/graphql_client.dart';
import 'package:flutter_app/core/graphql/__generated__/check_connectivity.graphql.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    AppGraphQLClient.resetClient();
  });

  group('GraphQL API Connectivity', () {
    test('connects to live backend and parses queryCheckConnectivity', () async {
      final client = await AppGraphQLClient.getClient();
      final result = await client.query$CheckConnectivity();

      expect(result.hasException, isFalse, reason: result.exception.toString());
      expect(result.parsedData, isNotNull);
      expect(result.parsedData!.channels, isA<List<String>>());
    });

    test('verifyConnectivity helper confirms live GraphQL health', () async {
      final isHealthy = await AppGraphQLClient.verifyConnectivity();
      expect(isHealthy, isTrue);
    });
  });
}
