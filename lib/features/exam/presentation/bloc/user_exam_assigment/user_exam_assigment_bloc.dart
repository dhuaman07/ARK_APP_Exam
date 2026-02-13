// lib/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_assigment_repository.dart';
import 'user_exam_assigment_event.dart';
import 'user_exam_assigment_state.dart';

class UserExamAssigmentBloc
    extends Bloc<UserExamAssigmentEvent, UserExamAssigmentState> {
  final UserExamAssigmentRepository repository;

  UserExamAssigmentBloc({required this.repository})
      : super(UserExamAssigmentInitial()) {
    on<LoadExamAssigment>(_onLoadExamAssigment);
  }

  Future<void> _onLoadExamAssigment(
    LoadExamAssigment event,
    Emitter<UserExamAssigmentState> emit,
  ) async {
    emit(UserExamAssigmentLoading());

    final result = await repository.getExamByUser(
      idUserExamAssigment: event.idFacultyExamAssigment,
    );

    result.fold(
      (failure) => emit(UserExamAssigmentError(
        message: _mapFailureToMessage(failure),
      )),
      (exam) => emit(UserExamAssigmentLoaded(exam: exam)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    if (failure is UnauthorizedFailure) return failure.message;
    return 'Error inesperado';
  }
}