import '../entities/dtr_entity.dart';

abstract class DtrRepository {
  Future<DtrCutoffEntity> getCutoffData(String cutoffText);
}
