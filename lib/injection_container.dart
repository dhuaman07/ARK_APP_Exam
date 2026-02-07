import 'dart:io'; // ⭐ AGREGAR ESTE IMPORT
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // ⭐ AGREGAR ESTE IMPORT
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ Features - Auth ============

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );

  // ============ Core ============

  // ============ External ============

  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl:
            'https://192.168.4.104:7066/api', // ✅ Tu IP ya está configurada
        //baseUrl: 'https://10.0.2.2:7066/api', // remoto
        connectTimeout: const Duration(seconds: 30), // ✅ Descomentar esto
        receiveTimeout: const Duration(seconds: 30), // ✅ Descomentar esto
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ⭐⭐⭐ AGREGAR ESTO - Permitir certificados auto-firmados ⭐⭐⭐
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print('🔓 Aceptando certificado de: $host:$port');
        return true; // Acepta todos los certificados (solo para desarrollo)
      };
      return client;
    };

    // Interceptores para logs y tokens
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true, // ⭐ Agregar para ver errores completos
      ),
    );

    return dio;
  });

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Secure Storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
