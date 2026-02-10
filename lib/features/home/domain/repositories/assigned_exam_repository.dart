import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/home/domain/entities/assigned_exam.dart';

abstract class AssignedExamRepository {
  Future<Either<Failure, List<AssignedExam>>> getAllFacultyExamAssigmentByUser({
    required String idUser
  });
}
