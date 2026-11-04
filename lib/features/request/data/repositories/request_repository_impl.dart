import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_datasource.dart';
import '../models/request_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  const RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RequestEntity>> getRequests() {
    return remoteDataSource.fetchRequests();
  }

  @override
  Future<bool> submitRequest(RequestEntity request) {
    return remoteDataSource.sendRequest(
      RequestModel(
        id: request.id,
        type: request.type,
        status: request.status,
        filingDate: request.filingDate,
        details: request.details,
      ),
    );
  }
}
