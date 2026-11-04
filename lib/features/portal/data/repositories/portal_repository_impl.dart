import '../../domain/entities/portal_summary_entity.dart';
import '../../domain/repositories/portal_repository.dart';
import '../datasources/portal_remote_datasource.dart';

class PortalRepositoryImpl implements PortalRepository {
  final PortalRemoteDataSource remoteDataSource;

  const PortalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PortalSummaryEntity> getPortalSummary() {
    return remoteDataSource.fetchPortalSummary();
  }
}
