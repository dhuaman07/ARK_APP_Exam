import 'package:dio/dio.dart';
import 'package:flutter_login_app/core/error/exceptions.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_create/user_exam_create.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_detail/user_exam_model.dart';

abstract class UserExamRemoteDataSource {
  Future<List<UserExamModel>> getAllExamsByUser(String idUser);
  Future<UserExamCreateModel> submitExam({required UserExamRequest request});
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
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserExamCreateModel> submitExam({
    required UserExamRequest request,
  }) async {
    try {
      final response = await dio.post(
        '/UserExam', // ← Tu endpoint real
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserExamCreateModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(message: 'Error al enviar el examen');
      }
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  // ✅ Manejo centralizado de errores Dio
  Never _handleDioException(DioException e) {
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
      message: e.response?.data?['message'] ?? 'Error del servidor',
    );
  }
}
