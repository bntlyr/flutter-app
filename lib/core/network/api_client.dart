import 'dart:convert';
import 'dart:io';
import '../errors/exceptions.dart';

/// Centralized API HTTP client wrapper with error handling using standard dart:io.
class ApiClient {
  final HttpClient _client;

  ApiClient({HttpClient? client}) : _client = client ?? HttpClient();

  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async {
    try {
      final request = await _client.getUrl(Uri.parse(url));
      headers?.forEach((k, v) => request.headers.set(k, v));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      return _processResponse(response.statusCode, body);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final request = await _client.postUrl(Uri.parse(url));
      request.headers.contentType = ContentType.json;
      headers?.forEach((k, v) => request.headers.set(k, v));
      if (body != null) {
        request.write(jsonEncode(body));
      }
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      return _processResponse(response.statusCode, responseBody);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Map<String, dynamic> _processResponse(int statusCode, String body) {
    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } else {
      throw ServerException('HTTP $statusCode: $body');
    }
  }
}
