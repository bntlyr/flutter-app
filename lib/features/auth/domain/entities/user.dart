/// Domain entity representing an authenticated user.
class User {
  final String id;
  final String email;
  final String name;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });
}
