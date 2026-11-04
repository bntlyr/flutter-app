import '../../domain/entities/payslip_entity.dart';
import '../../domain/repositories/payslip_repository.dart';
import '../datasources/payslip_remote_datasource.dart';

class PayslipRepositoryImpl implements PayslipRepository {
  final PayslipRemoteDataSource remoteDataSource;

  const PayslipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PayslipEntity> getPayslip(String cutoff) {
    return remoteDataSource.fetchPayslip(cutoff);
  }
}
