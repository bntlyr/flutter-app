import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class SubmitRequestUseCase {
  final RequestRepository repository;

  const SubmitRequestUseCase(this.repository);

  Future<bool> execute(RequestEntity request) {
    return repository.submitRequest(request);
  }
}
