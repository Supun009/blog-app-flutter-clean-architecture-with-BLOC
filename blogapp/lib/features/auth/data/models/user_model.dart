import 'package:blogapp/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
  });

  factory UserModel.fromjson(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
    );
  }
}
