/// Remote REST & GraphQL endpoint definitions.
class ApiEndpoints {
  static const String baseUrl = 'https://api.payrollneo.com';
  static const String graphqlUrl = '$baseUrl/graphql';

  // Auth
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String logout = '$baseUrl/api/v1/auth/logout';

  // Portal & Attendance
  static const String attendanceSummary = '$baseUrl/api/v1/attendance/summary';
  static const String timeIn = '$baseUrl/api/v1/attendance/time-in';
  static const String timeOut = '$baseUrl/api/v1/attendance/time-out';

  // Profile & DTR
  static const String profile = '$baseUrl/api/v1/employee/profile';
  static const String dtr = '$baseUrl/api/v1/employee/dtr';
}
