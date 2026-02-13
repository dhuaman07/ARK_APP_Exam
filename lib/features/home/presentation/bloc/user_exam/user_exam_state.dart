// lib/features/home/presentation/bloc/user_exam/user_exam_state.dart

import 'package:equatable/equatable.dart';
import '../../../../exam/domain/entities/user_exam_detail/user_exam.dart';

abstract class UserExamState extends Equatable {
  const UserExamState();

  @override
  List<Object> get props => [];
}

class UserExamInitial extends UserExamState {}

class UserExamLoading extends UserExamState {}

class UserExamLoaded extends UserExamState {
  final List<UserExam> userExams; // ✅ Nombre correcto

  const UserExamLoaded({required this.userExams});

  @override
  List<Object> get props => [userExams];
}

class UserExamError extends UserExamState {
  final String message;

  const UserExamError({required this.message});

  @override
  List<Object> get props => [message];
}
