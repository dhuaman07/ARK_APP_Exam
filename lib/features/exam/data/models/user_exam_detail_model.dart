// lib/features/user_exams/data/models/exam_question_detail_model.dart

import 'package:flutter_login_app/features/exam/data/models/user_exam_alternative_detail.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail.dart';

class UserExamDetailModel extends UserExamDetail {
  const UserExamDetailModel({
    required super.id,
    required super.idQuestion,
    required super.questionName,
    required super.alternatives,
  });

  factory UserExamDetailModel.fromJson(Map<String, dynamic> json) {
    return UserExamDetailModel(
      id: json['id'] ?? '',
      idQuestion: json['idQuestion'] ?? '',
      questionName: json['questionName'] ?? '',
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((alt) => UserExamAlternativeDetailModel.fromJson(
                  alt as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idQuestion': idQuestion,
      'questionName': questionName,
      'alternatives': alternatives
          .map((alt) => (alt as UserExamAlternativeDetailModel).toJson())
          .toList(),
    };
  }

  UserExamDetail toEntity() {
    return UserExamDetail(
      id: id,
      idQuestion: idQuestion,
      questionName: questionName,
      alternatives: alternatives.map((alt) => alt).toList(),
    );
  }
}
