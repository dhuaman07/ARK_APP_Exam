// lib/injection_container.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_login_app/features/exam/data/datasource/user_exam_remote_datasource.dart';
import 'package:flutter_login_app/features/exam/data/repositories/user_exam_repository_impl.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_repository.dart';
import 'package:flutter_login_app/features/exam/domain/usecases/get-all-user-exams.dart';
import 'package:flutter_login_app/features/home/data/datasource/assigned_exam_remote_datasource.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/user_exam/user_exam_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/auth_interceptor.dart';

// Auth imports
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// ✅ Home/AssignedExams imports
import 'features/home/data/repositories/assigned_exam_repository_impl.dart';
import 'features/home/domain/repositories/assigned_exam_repository.dart';
import 'features/home/domain/usecases/get_all_assigned_exams.dart';
import 'features/home/presentation/bloc/assigned_exam/assigned_exam_bloc.dart'; // ✅ AGREGAR

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

  // ============ Features - Home (AssignedExams) ============

  // ✅ AGREGAR: BLoC
  sl.registerFactory(
    () => AssignedExamBloc(
      getAllAssignedExams: sl(),
    ),
  );

  // ✅ AGREGAR: Use cases
  sl.registerLazySingleton(() => GetAllAssignedExams(sl()));

  // ✅ AGREGAR: Repository
  sl.registerLazySingleton<AssignedExamRepository>(
    () => AssignedExamRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // ✅ AGREGAR: Data sources
  sl.registerLazySingleton<AssignedExamRemoteDataSource>(
    () => AssignedExamRemoteDataSourceImpl(dio: sl()),
  );

// ============ Features - Exam (UserExam) ✅ NUEVO ============

  // BLoC
  sl.registerFactory(
    () => UserExamBloc(
      getAllUserExams: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllUserExams(sl()));

  // Repository
  sl.registerLazySingleton<UserExamRepository>(
    () => UserExamRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserExamRemoteDataSource>(
    () => UserExamRemoteDataSourceImpl(dio: sl()),
  );

  // ============ Core ============

  // ============ External ============

  // Dio
  // 10.98.69.129
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://10.98.69.129:7066/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Permitir certificados auto-firmados (solo desarrollo)
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print('🔓 Aceptando certificado de: $host:$port');
        return true;
      };
      return client;
    };

    // ✅ Interceptor de autenticación
    dio.interceptors.add(
      AuthInterceptor(authLocalDataSource: sl()),
    );

    // Interceptor de logs
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
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
