import 'package:equatable/equatable.dart';

class AssignedExam extends Equatable {
  final String idFacultyExam;
  final String typeExam;
  final int totalQuestions;

  const AssignedExam(
      {required this.idFacultyExam,
      required this.typeExam,
      required this.totalQuestions});

  String get questionsLabel => '$totalQuestions Questions';
  bool get hasQuestions => totalQuestions > 0;

  String get durationFormatted {
    final minutes = (totalQuestions * 2).clamp(15, 120);
    return '$minutes min';
  }

  @override
  List<Object?> get props => [idFacultyExam, typeExam, totalQuestions];
}
