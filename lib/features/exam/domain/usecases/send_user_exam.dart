// domain/usecases/submit_exam_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_create/user_exam_create.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_create/user_exam_create_result.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_repository.dart';

class SendUserExam {
  final UserExamRepository repository;

  SendUserExam({required this.repository});

  Future<Either<Failure, UserExamCreateResult>> call({
    required UserExamRequest request,
  }) {
    return repository.submitExam(request: request);
  }
}
