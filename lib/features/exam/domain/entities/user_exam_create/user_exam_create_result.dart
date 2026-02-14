class UserExamCreateResult {
  final String idUserExam;
  final bool success;
  final String message;
  final double score;

  const UserExamCreateResult({
    required this.idUserExam,
    required this.success,
    required this.message,
    required this.score,
  });
}
