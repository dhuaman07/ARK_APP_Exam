import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_login_app/features/home/domain/entities/assigned_exam.dart';
import 'package:flutter_login_app/features/home/domain/repositories/assigned_exam_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllAssignedExams implements UseCase<List<AssignedExam>, AssignedExamParams> {
  final AssignedExamRepository repository;
  
  GetAllAssignedExams(this.repository);
  
  @override
  Future<Either<Failure, List<AssignedExam>>> call(AssignedExamParams params) 
  async {
    return await repository.getAllFacultyExamAssigmentByUser(
      idUser: params.idUser
    );
  }
}

class AssignedExamParams extends Equatable {
  final String idUser;
  
  const AssignedExamParams({
    required this.idUser
  });
  
  @override
  List<Object> get props => [idUser];
}