import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam.dart';

abstract class UserExamRepository {
  Future<Either<Failure, List<UserExam>>> getAllExamsByUser(
      {required String idUser});
}
