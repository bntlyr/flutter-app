import '../entities/attendance.dart';
import '../repositories/dashboard_repository.dart';

/// Usecase for retrieving current attendance summary for dashboard.
class GetAttendanceSummaryUseCase {
  final DashboardRepository repository;

  const GetAttendanceSummaryUseCase(this.repository);

  Future<Attendance> execute() {
    return repository.getAttendanceSummary();
  }
}
