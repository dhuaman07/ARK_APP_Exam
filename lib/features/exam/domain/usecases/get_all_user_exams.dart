import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/core/usecases/usecase.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_repository.dart';

class GetAllUserExams implements UseCase<List<UserExam>, UserExamParams> {
  final UserExamRepository repository;

  GetAllUserExams(this.repository);

  @override
  Future<Either<Failure, List<UserExam>>> call(UserExamParams params) async {
    return await repository.getAllExamsByUser(idUser: params.idUser);
  }
}

class UserExamParams extends Equatable {
  final String idUser;

  const UserExamParams({required this.idUser});

  @override
  List<Object> get props => [idUser];
}