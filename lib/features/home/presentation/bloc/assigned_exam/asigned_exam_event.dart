// lib/features/home/presentation/bloc/assigned_exam_event.dart

import 'package:equatable/equatable.dart';

abstract class AssignedExamEvent extends Equatable {
  const AssignedExamEvent();

  @override
  List<Object> get props => [];
}

// ✅ Evento para cargar exámenes
class LoadAssignedExams extends AssignedExamEvent {
  final String userId;

  const LoadAssignedExams({required this.userId});

  @override
  List<Object> get props => [userId];
}

// ✅ Evento para refrescar exámenes
class RefreshAssignedExams extends AssignedExamEvent {
  final String userId;

  const RefreshAssignedExams({required this.userId});

  @override
  List<Object> get props => [userId];
}