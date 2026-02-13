import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/core/error/exceptions.dart';
import 'package:flutter_login_app/core/error/failures.dart';
import 'package:flutter_login_app/features/exam/data/datasource/user_exam_remote_datasource.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_repository.dart';

class UserExamRepositoryImpl implements UserExamRepository {
  final UserExamRemoteDataSource remoteDataSource;

  UserExamRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserExam>>> getAllExamsByUser({
    required String idUser,
  }) async {
    try {
      final models = await remoteDataSource.getAllExamsByUser(idUser);
      final entities = models.map((model) => model.toEntity()).toList();

      return Right(entities);
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
