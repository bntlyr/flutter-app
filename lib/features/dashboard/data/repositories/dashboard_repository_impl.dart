import '../../domain/entities/attendance.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

/// Implementation of DashboardRepository.
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({DashboardRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? DashboardRemoteDataSourceImpl();

  @override
  Future<Attendance> getAttendanceSummary() {
    return remoteDataSource.getAttendanceSummary();
  }

  @override
  Future<bool> recordTimeIn({required double lat, required double lng, String? address}) async {
    return true;
  }

  @override
  Future<bool> recordTimeOut({required double lat, required double lng, String? address}) async {
    return true;
  }
}
