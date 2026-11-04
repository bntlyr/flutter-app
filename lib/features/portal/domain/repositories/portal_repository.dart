import '../entities/portal_summary_entity.dart';

abstract class PortalRepository {
  Future<PortalSummaryEntity> getPortalSummary();
}
