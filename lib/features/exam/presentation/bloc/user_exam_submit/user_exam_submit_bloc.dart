import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/exam/domain/usecases/send_user_exam.dart';
import 'user_exam_submit_event.dart';
import 'user_exam_submit_state.dart';

class UserExamSubmitBloc
    extends Bloc<UserExamSubmitEvent, UserExamSubmitState> {
  final SendUserExam sendUserExam;

  UserExamSubmitBloc({required this.sendUserExam})
      : super(UserExamSubmitInitial()) {
    on<SubmitExamEvent>(_onSubmitExam);
    on<ResetSubmitExamEvent>(_onReset);
  }

  Future<void> _onSubmitExam(
    SubmitExamEvent event,
    Emitter<UserExamSubmitState> emit,
  ) async {
    emit(UserExamSubmitLoading());

    final result = await sendUserExam(request: event.request);

    result.fold(
      (failure) => emit(UserExamSubmitError(message: failure.message)),
      (examResult) => emit(UserExamSubmitSuccess(result: examResult)),
    );
  }

  void _onReset(
    ResetSubmitExamEvent event,
    Emitter<UserExamSubmitState> emit,
  ) =>
      emit(UserExamSubmitInitial());
}
