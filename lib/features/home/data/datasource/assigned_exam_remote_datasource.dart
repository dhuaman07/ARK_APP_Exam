// lib/features/home/data/datasources/assigned_exam_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/assigned_exam_model.dart';

abstract class AssignedExamRemoteDataSource {
  Future<List<AssignedExamModel>> getAllFacultyExamAssignmentByUser(String idUser);
}

class AssignedExamRemoteDataSourceImpl implements AssignedExamRemoteDataSource {
  final Dio dio;

  AssignedExamRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AssignedExamModel>> getAllFacultyExamAssignmentByUser(String idUser) async {
    try {
      final response = await dio.get('/facultyExamAssigment/by-user/$idUser');

      if (response.statusCode == 200) {
       final List<dynamic> data = response.data['data']; 
        
        return data
            .map((json) => AssignedExamModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(message: 'Error al cargar datos');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(message: 'Tiempo de espera agotado');
      }
      
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'Sin conexión a internet');
      }
      
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(message: 'Token inválido o expirado');
      }
      
      if (e.response?.statusCode == 403) {
        throw UnauthorizedException(message: 'No tienes permisos');
      }
      
      throw ServerException(
        message: e.response?.data['message'] ?? 'Error del servidor',
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }
}