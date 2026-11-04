import '../entities/payslip_entity.dart';

abstract class PayslipRepository {
  Future<PayslipEntity> getPayslip(String cutoff);
}
