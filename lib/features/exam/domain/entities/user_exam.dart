// lib/features/exam/domain/entities/user_exam.dart

import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail.dart';

class UserExam {
  final String idFacultyExam;
  final String typeExam;
  final DateTime assignedDate;
  final String? idUserExam; // ✅ Nullable
  final DateTime? startDate; // ✅ Nullable
  final DateTime? endDate; // ✅ Nullable
  final double finalGrade;
  final String status;
  final List<UserExamDetail> details; // ✅ Lista vacía si no hay details

  const UserExam({
    required this.idFacultyExam,
    required this.typeExam,
    required this.assignedDate,
    this.idUserExam,
    this.startDate,
    this.endDate,
    required this.finalGrade,
    required this.status,
    required this.details,
  });
}
