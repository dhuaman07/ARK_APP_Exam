import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/exceptions.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/data/datasource/user_exam_assigment_remote_datasource.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_assigment_repository.dart';

class UserExamAssigmentRepositoryImpl implements UserExamAssigmentRepository {
  final UserExamAssigmentRemoteDataSource remoteDataSource;

  UserExamAssigmentRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
Future<Either<Failure, AssigmentExam>> getExamByUser({
  required String idUserExamAssigment,  // ✅ con llaves {}
}) async {
  try {
    final model = await remoteDataSource.getExamByUser(idUserExamAssigment);
    return Right(model);
  } on UnauthorizedException catch (e) {
    return Left(UnauthorizedFailure(message: e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } catch (e) {
    return Left(ServerFailure(message: 'Error inesperado: ${e.toString()}'));
  }
}
}
