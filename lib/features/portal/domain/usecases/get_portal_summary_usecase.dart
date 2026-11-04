import '../entities/portal_summary_entity.dart';
import '../repositories/portal_repository.dart';

class GetPortalSummaryUseCase {
  final PortalRepository repository;

  const GetPortalSummaryUseCase(this.repository);

  Future<PortalSummaryEntity> execute() {
    return repository.getPortalSummary();
  }
}
