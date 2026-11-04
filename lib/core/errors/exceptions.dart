/// Application data-layer exception classes.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server exception occurred.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache exception occurred.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication exception.']);
}
