// lib/features/home/presentation/bloc/user_exam/user_exam_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/exam/domain/usecases/get_all_user_exams.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/user_exam/user-exam_event.dart';

import 'package:flutter_login_app/features/home/presentation/bloc/user_exam/user_exam_state.dart';

class UserExamBloc extends Bloc<UserExamEvent, UserExamState> {
  final GetAllUserExams getAllUserExams;

  UserExamBloc({
    required this.getAllUserExams,
  }) : super(UserExamInitial()) {
    on<LoadUserExams>(_onLoadUserExams);
    on<RefreshUserExams>(_onRefreshUserExams);
  }

  // ✅ Handler para cargar resultados de examenes usuario
  Future<void> _onLoadUserExams(
    LoadUserExams event,
    Emitter<UserExamState> emit,
  ) async {
    emit(UserExamLoading());

    final params = UserExamParams(idUser: event.userId);
    final result = await getAllUserExams(params);

    result.fold(
      (failure) => emit(UserExamError(message: failure.message)),
      (exams) => emit(UserExamLoaded(
          userExams: exams)), // ✅ CAMBIAR: userExams en vez de exams
    );
  }

  // ✅ Handler para refrescar resultados de examenes usuario
  Future<void> _onRefreshUserExams(
    RefreshUserExams event,
    Emitter<UserExamState> emit,
  ) async {
    // No emitir loading para refresh (mejor UX)
    final params = UserExamParams(idUser: event.userId);
    final result = await getAllUserExams(params);

    result.fold(
      (failure) => emit(UserExamError(message: failure.message)),
      (exams) => emit(UserExamLoaded(
          userExams: exams)), // ✅ CAMBIAR: userExams en vez de exams
    );
  }
}
