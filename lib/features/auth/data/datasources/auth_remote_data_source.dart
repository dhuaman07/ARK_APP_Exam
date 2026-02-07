import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      log("=====================================");
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password, 'ipAddress': ''},
      );

      if (response.statusCode == 200) {
        log("=====================================");
        log(jsonEncode(response.data));
        return UserModel.fromJson(response.data['data']['user']);
      } else {
        throw ServerException('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      log("=====================================");
      log("${e.message}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Tiempo de espera agotado');
      } else if (e.response?.statusCode == 401) {
        throw ServerException('Credenciales inválidas');
      } else {
        throw ServerException('Error del servidor');
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException {
      throw ServerException('Error al cerrar sesión');
    }
  }
}
