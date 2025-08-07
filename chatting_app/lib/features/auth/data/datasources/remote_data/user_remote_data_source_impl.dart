import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/constants/api_constant.dart';
import '../../../domain/entities/user.dart';
import '../../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final FlutterSecureStorage secureStorage;

  // Add default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  UserRemoteDataSourceImpl({
    required this.client,
    required this.secureStorage,
  });

  static const String _tokenKey = 'auth_token';

  @override
  Future<User> getUser() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  @override
  Future<User> registerUser(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: defaultHeaders,
      body: jsonEncode(UserModel.fromEntity(user).toRegisterJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  @override
  Future<User> loginUser(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: defaultHeaders,
      body: jsonEncode(UserModel.fromEntity(user).toLoginJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String?;
      if (token == null) {
        throw Exception('No token in login response');
      }
      await saveToken(token);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to login user: ${response.body}');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
  }
}