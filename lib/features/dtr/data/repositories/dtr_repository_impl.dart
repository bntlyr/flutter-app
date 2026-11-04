import '../../domain/entities/dtr_entity.dart';
import '../../domain/repositories/dtr_repository.dart';
import '../datasources/dtr_remote_datasource.dart';

class DtrRepositoryImpl implements DtrRepository {
  final DtrRemoteDataSource remoteDataSource;

  const DtrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DtrCutoffEntity> getCutoffData(String cutoffText) async {
    return remoteDataSource.fetchCutoff(cutoffText);
  }
}
