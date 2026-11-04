import '../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> fetchRequests();
  Future<bool> sendRequest(RequestModel request);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  @override
  Future<List<RequestModel>> fetchRequests() async {
    return const [];
  }

  @override
  Future<bool> sendRequest(RequestModel request) async {
    return true;
  }
}
