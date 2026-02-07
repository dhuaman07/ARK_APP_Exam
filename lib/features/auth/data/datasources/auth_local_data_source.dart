import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
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
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserKey,
        jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheException('Error al guardar usuario');
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
      throw CacheException('Error al obtener usuario');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await secureStorage.delete(key: tokenKey);
    } catch (e) {
      throw CacheException('Error al limpiar cache');
    }
  }
  
  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.write(key: tokenKey, value: token);
    } catch (e) {
      throw CacheException('Error al guardar token');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.read(key: tokenKey);
    } catch (e) {
      throw CacheException('Error al obtener token');
    }
  }
}
