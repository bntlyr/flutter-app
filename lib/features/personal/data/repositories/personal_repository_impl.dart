import 'package:flutter_app/shared/models/profile_model.dart';
import '../../domain/repositories/personal_repository.dart';
import '../datasources/personal_remote_datasource.dart';
import '../models/personal_schedule_model.dart';

/// Implementation of PersonalRepository coordinating remote GraphQL operations.
class PersonalRepositoryImpl implements PersonalRepository {
  final PersonalRemoteDataSource remoteDataSource;

  PersonalRepositoryImpl({PersonalRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? PersonalRemoteDataSourceImpl();

  @override
  Future<EmployeeProfile> getProfile() async {
    return remoteDataSource.getProfile();
  }

  @override
  Future<List<ShiftDayData>> getSchedule({
    required String userId,
    required DateTime month,
  }) async {
    final queryData = await remoteDataSource.getSchedule(
      userId: userId,
      month: month,
    );
    return PersonalScheduleMapper.fromQuery(
      data: queryData,
      targetMonth: month,
    );
  }
}
