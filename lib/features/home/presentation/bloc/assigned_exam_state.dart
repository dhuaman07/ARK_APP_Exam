// lib/features/home/presentation/bloc/assigned_exam_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/assigned_exam.dart';

abstract class AssignedExamState extends Equatable {
  const AssignedExamState();

  @override
  List<Object> get props => [];
}

// ✅ Estado inicial
class AssignedExamInitial extends AssignedExamState {}

// ✅ Estado de carga
class AssignedExamLoading extends AssignedExamState {}

// ✅ Estado de éxito con los exámenes cargados
class AssignedExamLoaded extends AssignedExamState {
  final List<AssignedExam> exams;

  const AssignedExamLoaded({required this.exams});

  @override
  List<Object> get props => [exams];
}

// ✅ Estado de error
class AssignedExamError extends AssignedExamState {
  final String message;

  const AssignedExamError({required this.message});

  @override
  List<Object> get props => [message];
}