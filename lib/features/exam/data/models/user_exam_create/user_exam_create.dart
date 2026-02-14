// ─── Request Detail ───────────────────────────────────────────
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_create/user_exam_create_result.dart';

class UserExamDetailRequest {
  final String idQuestion;
  final String idAlternative;

  const UserExamDetailRequest({
    required this.idQuestion,
    required this.idAlternative,
  });

  Map<String, dynamic> toJson() => {
        'idQuestion': idQuestion,
        'idAlternative': idAlternative,
      };
}

// ─── Request Principal ────────────────────────────────────────
class UserExamRequest {
  final String idUser;
  final String idFacultyExam;
  final DateTime startDate;
  final DateTime endDate;
  final List<UserExamDetailRequest> userExamDetail;

  const UserExamRequest({
    required this.idUser,
    required this.idFacultyExam,
    required this.startDate,
    required this.endDate,
    required this.userExamDetail,
  });

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idFacultyExam': idFacultyExam,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'userExamDetail': userExamDetail.map((d) => d.toJson()).toList(),
      };
}

// ─── Response / Model ─────────────────────────────────────────
class UserExamCreateModel {
  final String? idUserExam;
  final bool success;
  final String? message;
  final double? score;

  const UserExamCreateModel({
    this.idUserExam,
    required this.success,
    this.message,
    this.score,
  });

  factory UserExamCreateModel.fromJson(Map<String, dynamic> json) {
    return UserExamCreateModel(
      idUserExam: json['idUserExam'] as String?,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  // ✅ Model → Entity
  UserExamCreateResult toEntity() {
    return UserExamCreateResult(
      idUserExam: idUserExam ?? '',
      success: success,
      message: message ?? '',
      score: score ?? 0,
    );
  }
}
