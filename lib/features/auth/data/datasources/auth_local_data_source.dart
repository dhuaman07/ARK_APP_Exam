// lib/features/auth/data/datasources/auth_local_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveToken(String token);
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  
  static const String cachedUserKey = 'CACHED_USER';
  static const String tokenKey = 'AUTH_TOKEN';
  
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });
  
  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserKey,
        jsonEncode(user.toJson()),
      );
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw CacheException(message: 'Error al guardar usuario: ${e.toString()}');
    }
  }
  
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userString = sharedPreferences.getString(cachedUserKey);
      if (userString != null) {
        return UserModel.fromJson(jsonDecode(userString));
      }
      return null;
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw CacheException(message: 'Error al obtener usuario: ${e.toString()}');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await secureStorage.delete(key: tokenKey);
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw CacheException(message: 'Error al limpiar cache: ${e.toString()}');
    }
  }
  
  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.write(key: tokenKey, value: token);
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw CacheException(message: 'Error al guardar token: ${e.toString()}');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.read(key: tokenKey);
    } catch (e) {
      // ✅ CAMBIO: Usar parámetro nombrado 'message:'
      throw CacheException(message: 'Error al obtener token: ${e.toString()}');
    }
  }
}