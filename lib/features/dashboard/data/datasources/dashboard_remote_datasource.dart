import '../models/attendance_model.dart';

/// Remote data source contract for Dashboard.
abstract class DashboardRemoteDataSource {
  Future<AttendanceModel> getAttendanceSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<AttendanceModel> getAttendanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AttendanceModel(
      approvedRequests: 0,
      absent: 2.0,
      lateHrs: 0.017,
      undertimeHrs: 0.0,
      allowance: 632.0,
    );
  }
}
