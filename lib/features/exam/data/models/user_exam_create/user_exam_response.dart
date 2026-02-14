// data/models/user_exam_create/user_exam_response.dart

class UserExamResponse {
  final String? idUserExam;
  final bool success;
  final String? message;
  final double? score;

  const UserExamResponse({
    this.idUserExam,
    required this.success,
    this.message,
    this.score,
  });

  factory UserExamResponse.fromJson(Map<String, dynamic> json) {
    return UserExamResponse(
      idUserExam: json['idUserExam'] as String?,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }
}
