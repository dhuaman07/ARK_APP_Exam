// lib/injection_container.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_login_app/features/exam/data/datasource/user_exam_remote_datasource.dart';
import 'package:flutter_login_app/features/exam/data/repositories/user_exam_repository_impl.dart';
import 'package:flutter_login_app/features/exam/domain/repositories/user_exam_repository.dart';
import 'package:flutter_login_app/features/exam/domain/usecases/get_all_user_exams.dart';
import 'package:flutter_login_app/features/exam/domain/usecases/send_user_exam.dart'; // ✅ NUEVO
import 'package:flutter_login_app/features/exam/presentation/bloc/user_exam_submit/user_exam_submit_bloc.dart'; // ✅ NUEVO
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

// Home/AssignedExams imports
import 'features/home/data/repositories/assigned_exam_repository_impl.dart';
import 'features/home/domain/repositories/assigned_exam_repository.dart';
import 'features/home/domain/usecases/get_all_assigned_exams.dart';
import 'features/home/presentation/bloc/assigned_exam/assigned_exam_bloc.dart';

// UserExamAssigment imports
import 'features/exam/data/datasource/user_exam_assigment_remote_datasource.dart';
import 'features/exam/data/repositories/user_exam_assigment_repository_impl.dart';
import 'features/exam/domain/repositories/user_exam_assigment_repository.dart';
import 'features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_bloc.dart';

final sl = GetIt.instance;

const String _baseUrl = 'https://10.0.2.2:7066/api';

Future<void> init() async {
  // ============ Features - Auth ============

  sl.registerFactory(
    () => AuthBloc(loginUser: sl()),
  );
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
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

  sl.registerFactory(
    () => AssignedExamBloc(getAllAssignedExams: sl()),
  );
  sl.registerLazySingleton(() => GetAllAssignedExams(sl()));
  sl.registerLazySingleton<AssignedExamRepository>(
    () => AssignedExamRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AssignedExamRemoteDataSource>(
    () => AssignedExamRemoteDataSourceImpl(dio: sl()),
  );

  // ============ Features - Exam (UserExam) ============

  sl.registerFactory(
    () => UserExamBloc(getAllUserExams: sl()),
  );
  sl.registerLazySingleton(() => GetAllUserExams(sl()));

  // ✅ NUEVO: UseCase de submit
  sl.registerLazySingleton(() => SendUserExam(repository: sl()));

  sl.registerLazySingleton<UserExamRepository>(
    () => UserExamRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserExamRemoteDataSource>(
    () => UserExamRemoteDataSourceImpl(dio: sl()),
  );

  // ============ Features - Exam (UserExamAssigment) ============

  sl.registerFactory(
    () => UserExamAssigmentBloc(repository: sl()),
  );
  sl.registerLazySingleton<UserExamAssigmentRepository>(
    () => UserExamAssigmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserExamAssigmentRemoteDataSource>(
    () => UserExamAssigmentRemoteDataSourceImpl(dio: sl()),
  );

  // ============ Features - Exam (UserExamSubmit) ✅ NUEVO ============

  // registerFactory → cada página crea su propia instancia del BLoC
  sl.registerFactory(
    () => UserExamSubmitBloc(sendUserExam: sl()),
  );

  // ============ External ============

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print('🔓 Aceptando certificado de: $host:$port');
        return true;
      };
      return client;
    };

    dio.interceptors.add(AuthInterceptor(authLocalDataSource: sl()));
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

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
