import '../entities/payslip_entity.dart';
import '../repositories/payslip_repository.dart';

class GetPayslipUseCase {
  final PayslipRepository repository;

  const GetPayslipUseCase(this.repository);

  Future<PayslipEntity> execute(String cutoff) {
    return repository.getPayslip(cutoff);
  }
}
