import '../models/dtr_model.dart';

abstract class DtrRemoteDataSource {
  Future<DtrCutoffModel> fetchCutoff(String cutoffText);
}

class DtrRemoteDataSourceImpl implements DtrRemoteDataSource {
  @override
  Future<DtrCutoffModel> fetchCutoff(String cutoffText) async {
    // Remote integration stub
    return DtrCutoffModel(
      cutoffLabel: cutoffText,
      totalApprovedRequests: 0,
      totalAbsent: 0,
      totalLateHrs: 0,
      totalUndertimeHrs: 0,
      totalAllowance: 0,
      days: const [],
    );
  }
}
