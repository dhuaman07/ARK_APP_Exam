// lib/features/exam/domain/entities/user_exam_alternative_detail.dart

import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam_alternative_detail.dart';

class UserExamAlternativeDetailModel extends UserExamAlternativeDetail {
  const UserExamAlternativeDetailModel({
    required super.id,
    required super.alternativeRpta,
    required super.idAlternativeSelected,
    required super.isCorrectQst,
  });

  factory UserExamAlternativeDetailModel.fromJson(Map<String, dynamic> json) {
    return UserExamAlternativeDetailModel(
      id: json['id'] ?? '',
      alternativeRpta: json['alternativeRpta'] ?? '',
      idAlternativeSelected: json['idAlternativeSelected'] ?? '',
      isCorrectQst: json['isCorrectQst'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alternativeRpta': alternativeRpta,
      'idAlternativeSelected': idAlternativeSelected,
      'isCorrectQst': isCorrectQst,
    };
  }

  UserExamAlternativeDetail toEntity() {
    return UserExamAlternativeDetail(
      id: id,
      alternativeRpta: alternativeRpta,
      idAlternativeSelected: idAlternativeSelected,
      isCorrectQst: isCorrectQst,
    );
  }
}
