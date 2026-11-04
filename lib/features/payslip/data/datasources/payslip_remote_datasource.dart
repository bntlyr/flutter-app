import '../models/payslip_model.dart';

abstract class PayslipRemoteDataSource {
  Future<PayslipModel> fetchPayslip(String cutoff);
}

class PayslipRemoteDataSourceImpl implements PayslipRemoteDataSource {
  @override
  Future<PayslipModel> fetchPayslip(String cutoff) async {
    return PayslipModel(
      cutoff: cutoff,
      netPay: 23500.0,
      totalGross: 25000.0,
      totalDeductions: 1500.0,
    );
  }
}
