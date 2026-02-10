// lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter_login_app/features/auth/data/datasources/auth_local_data_source.dart';


class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({required this.authLocalDataSource});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ Obtener token del almacenamiento
    final token = await authLocalDataSource.getToken();

    // ✅ Agregar token al header si existe
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // ✅ Continuar con la petición
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ✅ Manejo especial para errores 401 (token expirado)
    if (err.response?.statusCode == 401) {
      // Aquí podrías limpiar el cache y redirigir al login
      // authLocalDataSource.clearCache();
    }

    super.onError(err, handler);
  }
}