import 'package:flutter_login_app/features/exam/domain/entities/user_exam_create/user_exam_create_result.dart';

abstract class UserExamSubmitState {}

class UserExamSubmitInitial extends UserExamSubmitState {}

class UserExamSubmitLoading extends UserExamSubmitState {}

class UserExamSubmitSuccess extends UserExamSubmitState {
  final UserExamCreateResult result;

  UserExamSubmitSuccess({required this.result});
}

class UserExamSubmitError extends UserExamSubmitState {
  final String message;

  UserExamSubmitError({required this.message});
}
