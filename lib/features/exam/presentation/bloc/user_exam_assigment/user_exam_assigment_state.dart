// lib/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_state.dart

import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';

abstract class UserExamAssigmentState {}

class UserExamAssigmentInitial extends UserExamAssigmentState {}

class UserExamAssigmentLoading extends UserExamAssigmentState {}

class UserExamAssigmentLoaded extends UserExamAssigmentState {
  final AssigmentExam exam;
  UserExamAssigmentLoaded({required this.exam});
}

class UserExamAssigmentError extends UserExamAssigmentState {
  final String message;
  UserExamAssigmentError({required this.message});
}