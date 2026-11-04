import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Remote REST & GraphQL endpoint definitions.
class ApiEndpoints {
  // Configurable base host/port
  static const int port = 4002;
  static const String prodBaseUrl = 'https://api.payrollneo.com';

  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String _envHost = String.fromEnvironment('API_HOST');

  /// Resolves local dev URL based on runtime platform and environment.
  /// Defaults to host Mac Wi-Fi IPv4 (192.168.1.153:4002) for real devices and emulators.
  static String get devBaseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    if (_envHost.isNotEmpty) {
      return 'http://$_envHost:$port';
    }
    if (kIsWeb) {
      return 'http://localhost:$port';
    }
    if (Platform.isAndroid) {
      return 'http://192.168.1.153:$port';
    }
    return 'http://localhost:$port';
  }

  /// Current active base URL. Can be modified at runtime for custom LAN environments.
  static String activeBaseUrl = devBaseUrl;

  static void setBaseUrl(String url) {
    var cleaned = url.trim();
    if (cleaned.endsWith('/')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    if (!cleaned.startsWith('http://') && !cleaned.startsWith('https://')) {
      cleaned = 'http://$cleaned';
    }
    activeBaseUrl = cleaned;
  }

  static String get baseUrl => activeBaseUrl;
  static String get graphqlUrl => '$baseUrl/graphql';
  static String get publicKeyUrl => '$baseUrl/api/key';

  // REST Auth
  static String get login => '$baseUrl/api/v1/auth/login';
  static String get register => '$baseUrl/api/v1/auth/register';
  static String get logout => '$baseUrl/api/v1/auth/logout';

  // Portal & Attendance
  static String get attendanceSummary => '$baseUrl/api/v1/attendance/summary';
  static String get timeIn => '$baseUrl/api/v1/attendance/time-in';
  static String get timeOut => '$baseUrl/api/v1/attendance/time-out';

  // Profile & DTR
  static String get profile => '$baseUrl/api/v1/employee/profile';
  static String get dtr => '$baseUrl/api/v1/employee/dtr';
}
