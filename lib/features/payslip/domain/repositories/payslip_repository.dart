import '../entities/payslip_entity.dart';

abstract class PayslipRepository {
  Future<PayslipEntity> getPayslip({String? cutoffId, String? cutoffText});
  Future<List<CutoffOptionEntity>> getCutoffs();
}
