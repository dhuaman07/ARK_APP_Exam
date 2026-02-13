import 'package:dio/dio.dart';
import 'package:flutter_login_app/core/error/exceptions.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_assigment/user_exam_assigment_model.dart';

abstract class UserExamAssigmentRemoteDataSource {
  Future<AssigmentExamModel> getExamByUser(String idUserExamAssigment);
}

class UserExamAssigmentRemoteDataSourceImpl implements UserExamAssigmentRemoteDataSource {
  final Dio dio;

  UserExamAssigmentRemoteDataSourceImpl({required this.dio});

  @override
  Future<AssigmentExamModel> getExamByUser(String idUserExamAssigment) async {
  try {
    final response = await dio.get('/UserExam/assigment/$idUserExamAssigment');

    if (response.statusCode == 200) {
      // ✅ data es un objeto único, no una lista
      final Map<String, dynamic> data = response.data['data'];
      return AssigmentExamModel.fromJson(data);
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
