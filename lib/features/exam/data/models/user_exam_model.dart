// lib/features/exam/data/models/user_exam_model.dart

import 'package:flutter_login_app/features/exam/data/models/user_exam_detail_model.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam.dart';

class UserExamModel extends UserExam {
  const UserExamModel({
    required super.idFacultyExam,
    required super.typeExam,
    required super.assignedDate,
    super.idUserExam,
    super.startDate,
    super.endDate,
    required super.finalGrade,
    required super.status,
    required super.details,
  });

  factory UserExamModel.fromJson(Map<String, dynamic> json) {
    return UserExamModel(
      idFacultyExam: json['idFacultyExam'] as String? ?? '',
      typeExam: json['typeExam'] as String? ?? '',
      assignedDate: _parseDateTime(json['assignedDate']) ?? DateTime.now(),
      idUserExam: json['idUserExam'] as String?, // ✅ Puede ser null
      startDate: _parseDateTime(json['startDate']), // ✅ Puede ser null
      endDate: _parseDateTime(json['endDate']), // ✅ Puede ser null
      finalGrade: _parseToDouble(json['finalGrade']) ?? 0.0,
      status: json['status'] as String? ?? '',
      details: _parseDetails(json['details']), // ✅ Manejo seguro
    );
  }

  // ✅ Parseo seguro de details
  static List<UserExamDetailModel> _parseDetails(dynamic detailsJson) {
    if (detailsJson == null) return [];
    if (detailsJson is! List) return [];

    try {
      return detailsJson
          .map((detail) {
            if (detail is Map<String, dynamic>) {
              return UserExamDetailModel.fromJson(detail);
            }
            return null;
          })
          .whereType<UserExamDetailModel>() // Filtrar nulls
          .toList();
    } catch (e) {
      print('❌ Error parseando details: $e');
      return [];
    }
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('❌ Error parseando fecha: $value');
        return null;
      }
    }
    return null;
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('❌ Error parseando double: $value');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'idFacultyExam': idFacultyExam,
      'typeExam': typeExam,
      'assignedDate': assignedDate.toIso8601String(),
      if (idUserExam != null) 'idUserExam': idUserExam,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'finalGrade': finalGrade,
      'status': status,
      'details': details
          .map((detail) => (detail as UserExamDetailModel).toJson())
          .toList(),
    };
  }

  UserExam toEntity() {
    return UserExam(
      idFacultyExam: idFacultyExam,
      typeExam: typeExam,
      assignedDate: assignedDate,
      idUserExam: idUserExam,
      startDate: startDate,
      endDate: endDate,
      finalGrade: finalGrade,
      status: status,
      details: details,
    );
  }
}
