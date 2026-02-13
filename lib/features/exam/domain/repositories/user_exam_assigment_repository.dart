import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';

abstract class UserExamAssigmentRepository {
  Future<Either<Failure, AssigmentExam>> getExamByUser(
      {required String idUserExamAssigment});
}