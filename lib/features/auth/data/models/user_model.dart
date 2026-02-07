import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
    required super.firstName,
    required super.lastName,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName
    };
  }
  
  User toEntity() {
    return User(
      id: id,
      email: email,
      userName: userName,
      firstName: firstName,
      lastName: lastName
    );
  }
}
