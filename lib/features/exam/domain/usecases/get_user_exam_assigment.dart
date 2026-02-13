import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/core/usecases/usecase.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_assigment_repository.dart';

class GetUserExams implements UseCase<AssigmentExam, UserExamAssigmentParams> {
  final UserExamAssigmentRepository repository;

  GetUserExams(this.repository);

  @override
  Future<Either<Failure, AssigmentExam>> call(UserExamAssigmentParams params) async {
    return await repository.getExamByUser(idUserExamAssigment: params.idFacultyExamAssigment);
  }
}

class UserExamAssigmentParams extends Equatable {
  final String idFacultyExamAssigment;

  const UserExamAssigmentParams({required this.idFacultyExamAssigment});

  @override
  List<Object> get props => [idFacultyExamAssigment];
}