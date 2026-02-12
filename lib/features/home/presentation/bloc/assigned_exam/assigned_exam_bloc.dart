// lib/features/home/presentation/bloc/assigned_exam_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/home/domain/usecases/get_all_assigned_exams.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/assigned_exam/asigned_exam_event.dart';
import 'assigned_exam_state.dart';

class AssignedExamBloc extends Bloc<AssignedExamEvent, AssignedExamState> {
  final GetAllAssignedExams getAllAssignedExams;

  AssignedExamBloc({
    required this.getAllAssignedExams,
  }) : super(AssignedExamInitial()) {
    // ✅ Registrar handlers de eventos
    on<LoadAssignedExams>(_onLoadAssignedExams);
    on<RefreshAssignedExams>(_onRefreshAssignedExams);
  }

  // ✅ Handler para cargar exámenes
  Future<void> _onLoadAssignedExams(
    LoadAssignedExams event,
    Emitter<AssignedExamState> emit,
  ) async {
    emit(AssignedExamLoading());

    final params = AssignedExamParams(idUser: event.userId);
    final result = await getAllAssignedExams(params);

    result.fold(
      (failure) => emit(AssignedExamError(message: failure.message)),
      (exams) => emit(AssignedExamLoaded(exams: exams)),
    );
  }

  // ✅ Handler para refrescar exámenes
  Future<void> _onRefreshAssignedExams(
    RefreshAssignedExams event,
    Emitter<AssignedExamState> emit,
  ) async {
    // No emitir loading para refresh (mejor UX)
    final params = AssignedExamParams(idUser: event.userId);
    final result = await getAllAssignedExams(params);

    result.fold(
      (failure) => emit(AssignedExamError(message: failure.message)),
      (exams) => emit(AssignedExamLoaded(exams: exams)),
    );
  }
}
