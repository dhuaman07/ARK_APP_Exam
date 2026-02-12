import 'package:dio/dio.dart';
import 'package:flutter_login_app/core/error/exceptions.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_model.dart';

abstract class UserExamRemoteDataSource {
  Future<List<UserExamModel>> getAllExamsByUser(String idUser);
}

class UserExamRemoteDataSourceImpl implements UserExamRemoteDataSource {
  final Dio dio;

  UserExamRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserExamModel>> getAllExamsByUser(String idUser) async {
    try {
      final response = await dio.get('/UserExam/by-user/$idUser');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        return data
            .map((json) => UserExamModel.fromJson(json as Map<String, dynamic>))
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
