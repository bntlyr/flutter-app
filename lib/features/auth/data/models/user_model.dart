import '../../domain/entities/user.dart';

/// Data transfer model for User entity with serialization.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.name,
    super.token,
    super.companyId,
    super.companyName,
    super.databaseName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      token: json['token'] as String?,
      companyId: json['companyId'] as String?,
      companyName: json['companyName'] as String?,
      databaseName: json['databaseName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      if (token != null) 'token': token,
      if (companyId != null) 'companyId': companyId,
      if (companyName != null) 'companyName': companyName,
      if (databaseName != null) 'databaseName': databaseName,
    };
  }
}
