import '../entities/dtr_entity.dart';
import '../repositories/dtr_repository.dart';

class GetDtrCutoffUseCase {
  final DtrRepository repository;

  const GetDtrCutoffUseCase(this.repository);

  Future<DtrCutoffEntity> execute(String cutoffText) {
    return repository.getCutoffData(cutoffText);
  }
}
