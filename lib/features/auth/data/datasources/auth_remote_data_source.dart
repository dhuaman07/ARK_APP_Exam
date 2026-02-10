// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:flutter_login_app/features/auth/data/models/auth_response_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'ipAddress': '',
        },
      );

      if (response.statusCode == 200) {
        // ✅ Verificar que la respuesta tenga la estructura esperada
        if (response.data == null) {
          throw ServerException(message: 'Respuesta vacía del servidor');
        }

        if (response.data['data'] == null || response.data['data']['user'] == null) {
          throw ServerException(message: 'Formato de respuesta inválido');
        }

        return AuthResponseModel.fromJson(response.data);
      } else {
        // ✅ CAMBIO: Usar parámetro nombrado 'message:'
        throw ServerException(
          message: 'Error al iniciar sesión: código ${response.statusCode}',
        );
      }
    } on ServerException {
      // ✅ Re-lanzar excepciones de servidor que ya creamos
      rethrow;
    } on DioException catch (e) {
      // ✅ Manejo de errores de red con Dio
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // ✅ CAMBIO: Usar parámetro nombrado 'message:'
        throw NetworkException(message: 'Tiempo de espera agotado');
      }

      if (e.type == DioExceptionType.connectionError) {
        // ✅ CAMBIO: Usar parámetro nombrado 'message:'
        throw NetworkException(message: 'Error de conexión. Verifica tu internet');
      }

      if (e.response?.statusCode == 401) {
        // ✅ CAMBIO: Usar parámetro nombrado 'message:' y mensaje del backend
        final message = e.response?.data['message'] ?? 'Credenciales inválidas';
        throw UnauthorizedException(message: message);
      }

      if (e.response?.statusCode == 400) {
        // ✅ Validación del backend
        final message = e.response?.data['message'] ?? 'Datos inválidos';
        throw ServerException(message: message);
      }

      if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Servicio no encontrado');
      }

      if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Error interno del servidor');
      }

      // ✅ CAMBIO: Error genérico con más contexto
      throw ServerException(
        message: e.response?.data['message'] ?? 'Error del servidor: ${e.message}',
      );
    } on FormatException catch (e) {
      // ✅ Error al parsear JSON
      throw ServerException(
        message: 'Error al procesar respuesta del servidor: ${e.message}',
      );
    } catch (e) {
      // ✅ CAMBIO: Cualquier otro error
      throw ServerException(
        message: 'Error inesperado: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await dio.post('/auth/logout');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Error al cerrar sesión: código ${response.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(message: 'Tiempo de espera agotado');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'Error de conexión');
      }

      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw ServerException(
        message: e.response?.data['message'] ?? 'Error al cerrar sesión',
      );
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw ServerException(
        message: 'Error inesperado al cerrar sesión: ${e.toString()}',
      );
    }
  }
}