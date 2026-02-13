import 'package:flutter_login_app/features/home/domain/entities/assigned_exam.dart';

class AssignedExamModel extends AssignedExam {
  const AssignedExamModel({
    required super.idFacultyExamAssigment,
    required super.idFacultyExam,
    required super.typeExam,
    required super.totalQuestions,
  });

  factory AssignedExamModel.fromJson(Map<String, dynamic> json) {
    return AssignedExamModel(
      idFacultyExamAssigment: json['idFacultyExamAssigment'] ?? '',
      idFacultyExam: json['idFacultyExam'] ?? '',
      typeExam: json['typeExam'] ?? '',
      totalQuestions: _parseToInt(json['totalQuestions']) ?? 0,
    );
  }

  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'idFacultyExamAssigment': idFacultyExamAssigment,
      'idFacultyExam': idFacultyExam,
      'typeExam': typeExam,
      'totalQuestions': totalQuestions
    };
  }

  AssignedExam toEntity() {
    return AssignedExam(
        idFacultyExamAssigment: idFacultyExamAssigment,
        idFacultyExam: idFacultyExam,
        typeExam: typeExam,
        totalQuestions: totalQuestions);
  }
}
