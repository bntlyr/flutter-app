/// Domain entity representing an authenticated user.
class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String? token;
  final String? companyId;
  final String? companyName;
  final String? databaseName;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.token,
    this.companyId,
    this.companyName,
    this.databaseName,
  });
}
