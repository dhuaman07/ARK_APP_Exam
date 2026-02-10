import 'package:flutter_login_app/features/auth/data/models/user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthResponseModel(
      accessToken: data['accessToken'],
      tokenType: data['tokenType'],
      expiresIn: data['expiresIn'],
      user: UserModel.fromJson(data['user']),
    );
  }
}
