import 'dart:convert';

import 'package:yconic/data/mappers/user_model_mapper.dart';
import 'package:yconic/data/models/user_model.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final String baseUrl;
  final http.Client client;

  UserRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<User> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'ContentType': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userModel = UserModel.fromJson(data);
      return userModel.toEntity();
    } else {
      throw Exception('Login Unsuccessful : ${response.statusCode}');
    }
  }

  @override
  Future<User> register(
      String email,
      String password,
      String confirmPassword,
      String name,
      String surname,
      DateTime birthday,
      String phoneNumber) async {
    final response = await client.post(Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'name': name,
          'surname': surname,
          'birthday': birthday,
          'phoneNumber': phoneNumber
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userModel = UserModel.fromJson(data);
      return userModel.toEntity();
    } else {
      throw Exception('Registeration has been failed:  ${response.statusCode}');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/user/$id'),
        headers: {'Content-Type': 'aplication/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userModel = UserModel.fromJson(data);
      return userModel.toEntity();
    } else {
      throw Exception('There is no user with that Id: ${response.statusCode}');
    }
  }
}
