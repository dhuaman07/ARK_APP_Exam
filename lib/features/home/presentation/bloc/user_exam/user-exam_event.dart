// lib/features/home/presentation/bloc/User_exam_event.dart

import 'package:equatable/equatable.dart';

abstract class UserExamEvent extends Equatable {
  const UserExamEvent();

  @override
  List<Object> get props => [];
}

// ✅ Evento para cargar resultados de examenes usuario
class LoadUserExams extends UserExamEvent {
  final String userId;

  const LoadUserExams({required this.userId});

  @override
  List<Object> get props => [userId];
}

// ✅ Evento para refrescar resultados de examenes usuario
class RefreshUserExams extends UserExamEvent {
  final String userId;

  const RefreshUserExams({required this.userId});

  @override
  List<Object> get props => [userId];
}
