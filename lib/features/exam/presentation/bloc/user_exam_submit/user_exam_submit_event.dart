import 'package:flutter_login_app/features/exam/data/models/user_exam_create/user_exam_create.dart';

abstract class UserExamSubmitEvent {}

class SubmitExamEvent extends UserExamSubmitEvent {
  final UserExamRequest request;

  SubmitExamEvent({required this.request});
}

class ResetSubmitExamEvent extends UserExamSubmitEvent {}
