import 'dart:convert';
import 'package:graphql/client.dart' as gql;
import 'package:flutter_app/core/errors/exceptions.dart';
import 'package:flutter_app/core/graphql/graphql_client.dart';
import 'package:flutter_app/core/graphql/__generated__/schema.graphql.dart';
import 'package:flutter_app/features/personal/data/models/personal_model.dart';
import 'package:flutter_app/services/storage_service.dart';
import '../graphql/__generated__/personal.graphql.dart';
import '../graphql/__generated__/schedule.graphql.dart';

/// Remote data source contract for Personal Profile & Schedule.
abstract class PersonalRemoteDataSource {
  Future<EmployeeProfile> getProfile();
  Future<Query$Schedule> getSchedule({
    required String userId,
    required DateTime month,
  });
}

class PersonalRemoteDataSourceImpl implements PersonalRemoteDataSource {
  final gql.GraphQLClient? graphqlClient;
  final StorageService? storageService;

  PersonalRemoteDataSourceImpl({
    this.graphqlClient,
    this.storageService,
  });

  Future<gql.GraphQLClient> get _client async =>
      graphqlClient ?? await AppGraphQLClient.getClient();

  Future<StorageService> get _storage async =>
      storageService ?? await StorageService.getInstance();

  @override
  Future<EmployeeProfile> getProfile() async {
    final client = await _client;
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final result = await client.query$Personal(
      Options$Query$Personal(
        variables: Variables$Query$Personal(time: timeStr),
        fetchPolicy: gql.FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final errors = result.exception?.graphqlErrors;
      if (errors != null && errors.isNotEmpty) {
        throw ServerException(errors.first.message);
      }
      final linkEx = result.exception?.linkException;
      throw ServerException(linkEx?.toString() ?? 'Network error fetching profile');
    }

    final data = result.parsedData;
    if (data == null || data.me == null) {
      throw const ServerException('No profile data received from server.');
    }

    return PersonalModelMapper.fromQuery(data);
  }

  @override
  Future<Query$Schedule> getSchedule({
    required String userId,
    required DateTime month,
  }) async {
    final client = await _client;
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);

    final startStr =
        '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
    final endStr =
        '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';

    final dateRange = Input$DailyDateInputFilter(
      start: startStr,
      end: endStr,
    );

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    String effectiveUserId = userId;
    if (effectiveUserId.isEmpty || effectiveUserId == 'me' || !effectiveUserId.contains('-')) {
      final storage = await _storage;
      final token = await storage.getToken();
      if (token != null && token.contains('.')) {
        try {
          final payloadStr = utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1])));
          final payload = jsonDecode(payloadStr) as Map<String, dynamic>;
          effectiveUserId = payload['userId'] ?? payload['id'] ?? effectiveUserId;
        } catch (_) {}
      }
    }

    final filter = Input$RequestInputFilter(
      userId: effectiveUserId,
      targetDateFrom: startStr,
      targetDateTo: endStr,
      typeOfRequest: 'Leave',
      approvalStatus: 'Approved',
    );

    final result = await client.query$Schedule(
      Options$Query$Schedule(
        variables: Variables$Query$Schedule(
          userId: effectiveUserId,
          dateRange: dateRange,
          targetDate: endStr,
          time: timeStr,
          filter: filter,
        ),
        fetchPolicy: gql.FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final errors = result.exception?.graphqlErrors;
      if (errors != null && errors.isNotEmpty) {
        throw ServerException(errors.first.message);
      }
      final linkEx = result.exception?.linkException;
      throw ServerException(linkEx?.toString() ?? 'Network error fetching schedule');
    }

    final data = result.parsedData;
    if (data == null) {
      throw const ServerException('No schedule data received.');
    }

    return data;
  }
}
