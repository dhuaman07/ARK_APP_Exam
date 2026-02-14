import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_create/user_exam_create.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_create/user_exam_create_result.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam.dart';

abstract class UserExamRepository {
  Future<Either<Failure, List<UserExam>>> getAllExamsByUser(
      {required String idUser});

  Future<Either<Failure, UserExamCreateResult>> submitExam({
    required UserExamRequest request,
  });
}
