// lib/features/exam/domain/entities/user_exam_alternative_detail.dart

class UserExamAlternativeDetail {
  final String id;
  final String alternativeRpta;
  final String idAlternativeSelected;
  final bool isCorrectQst;

  const UserExamAlternativeDetail({
    required this.id,
    required this.alternativeRpta,
    required this.idAlternativeSelected,
    required this.isCorrectQst,
  });
}
