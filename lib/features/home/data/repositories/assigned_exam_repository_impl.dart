// lib/features/home/data/repositories/assigned_exam_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_login_app/features/home/data/datasource/assigned_exam_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/assigned_exam.dart';
import '../../domain/repositories/assigned_exam_repository.dart'; // ✅ IMPORT del DataSource

class AssignedExamRepositoryImpl implements AssignedExamRepository {
  // ✅ ERROR 1: Debe ser AssignedExamRemoteDataSource, NO AssignedExamRepository
  final AssignedExamRemoteDataSource remoteDataSource;

  AssignedExamRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<AssignedExam>>> getAllFacultyExamAssigmentByUser({
    required String idUser,
  }) async {
    try {
      // ✅ ERROR 2: Esto retorna List<AssignedExamModel>, NO Either
      final models = await remoteDataSource.getAllFacultyExamAssignmentByUser(idUser);
      
      // ✅ ERROR 3: Debes mapear cada modelo a entidad
      final entities = models.map((model) => model.toEntity()).toList();
      
      return Right(entities);
    } on UnauthorizedException catch (e) {
      // ✅ AGREGAR: Manejo de errores de autenticación
      return Left(UnauthorizedFailure(message: e.message));
    } on NetworkException catch (e) {
      // ✅ ERROR 4: Usar parámetro nombrado 'message:'
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