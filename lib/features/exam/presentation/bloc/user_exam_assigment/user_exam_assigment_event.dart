// lib/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_event.dart

abstract class UserExamAssigmentEvent {}

class LoadExamAssigment extends UserExamAssigmentEvent {
  final String idFacultyExamAssigment;

  LoadExamAssigment({required this.idFacultyExamAssigment});
}