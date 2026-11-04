import '../models/portal_summary_model.dart';

abstract class PortalRemoteDataSource {
  Future<PortalSummaryModel> fetchPortalSummary();
}

class PortalRemoteDataSourceImpl implements PortalRemoteDataSource {
  @override
  Future<PortalSummaryModel> fetchPortalSummary() async {
    return const PortalSummaryModel(
      employeeName: 'Paul Javinez',
      date: 'Today',
      timeIn: '08:00',
      timeOut: null,
      basicPay: 25000.0,
      netPay: 23500.0,
    );
  }
}
