import '../entities/attendance.dart';

/// Contract for Dashboard repository operations.
abstract class DashboardRepository {
  Future<Attendance> getAttendanceSummary();
  Future<bool> recordTimeIn({required double lat, required double lng, String? address});
  Future<bool> recordTimeOut({required double lat, required double lng, String? address});
}
