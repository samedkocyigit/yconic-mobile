import 'dart:convert';

import 'package:yconic/core/services/token_service.dart';
import 'package:yconic/data/mappers/user_model_mapper.dart';
import 'package:yconic/data/models/user_model.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final String baseUrl;
  final http.Client client;
  final TokenService tokenService;

  UserRepositoryImpl(
      {required this.baseUrl, required this.tokenService, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<User> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data']['user'];
      final userModel = UserModel.fromJson(userJson);
      final token = data['data']['token'];
      await tokenService.saveToken(token);

      return userModel.toEntity();
    } else {
      throw Exception('Login Unsuccessful : ${response.statusCode}');
    }
  }

  @override
  Future<void> register(
    String email,
    String username,
    String password,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/Register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Registeration has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/User/$id'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final userModel = UserModel.fromJson(userJson);
      return userModel.toEntity();
    } else {
      throw Exception('There is no user with that Id: ${response.statusCode}');
    }
  }
}
