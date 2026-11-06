import '../../domain/entities/payslip_entity.dart';
import '../../domain/repositories/payslip_repository.dart';
import '../datasources/payslip_remote_datasource.dart';

class PayslipRepositoryImpl implements PayslipRepository {
  final PayslipRemoteDataSource remoteDataSource;

  const PayslipRepositoryImpl({
    PayslipRemoteDataSource? remoteDataSource,
  }) : remoteDataSource = remoteDataSource ?? const PayslipRemoteDataSourceImpl();

  @override
  Future<PayslipEntity> getPayslip({String? cutoffId, String? cutoffText}) {
    return remoteDataSource.fetchPayslip(cutoffId: cutoffId, cutoffText: cutoffText);
  }

  @override
  Future<List<CutoffOptionEntity>> getCutoffs() {
    return remoteDataSource.fetchCutoffs();
  }
}
