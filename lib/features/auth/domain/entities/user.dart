import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String lastName;
  
  const User({
    required this.id,
    required this.email,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });
  
  @override
  List<Object?> get props => [id, email, userName, firstName, lastName];
}
