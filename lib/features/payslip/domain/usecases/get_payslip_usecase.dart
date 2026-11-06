import '../entities/payslip_entity.dart';
import '../repositories/payslip_repository.dart';

class GetPayslipUseCase {
  final PayslipRepository repository;

  const GetPayslipUseCase(this.repository);

  Future<PayslipEntity> execute({String? cutoffId, String? cutoffText}) {
    return repository.getPayslip(cutoffId: cutoffId, cutoffText: cutoffText);
  }

  Future<List<CutoffOptionEntity>> getCutoffs() {
    return repository.getCutoffs();
  }
}
