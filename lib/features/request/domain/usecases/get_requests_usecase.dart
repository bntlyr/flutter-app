import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class GetRequestsUseCase {
  final RequestRepository repository;

  const GetRequestsUseCase(this.repository);

  Future<List<RequestEntity>> execute() {
    return repository.getRequests();
  }
}
