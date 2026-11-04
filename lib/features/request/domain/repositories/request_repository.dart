import '../entities/request_entity.dart';

abstract class RequestRepository {
  Future<List<RequestEntity>> getRequests();
  Future<bool> submitRequest(RequestEntity request);
}
