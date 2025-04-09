import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yconic/core/services/token_service.dart';
import 'package:yconic/data/dtos/user/change_password_dto.dart';
import 'package:yconic/data/dtos/user/change_profile_photo_dto.dart';
import 'package:yconic/data/dtos/user/update_user_account_dto.dart';
import 'package:yconic/data/dtos/user/update_user_personal_dto.dart';
import 'package:yconic/data/mappers/public_user_profile_model_mapper.dart';
import 'package:yconic/data/mappers/simple_user_model_mapper.dart';
import 'package:yconic/data/mappers/user_model_mapper.dart';
import 'package:yconic/data/models/public_user_profile_model.dart';
import 'package:yconic/data/models/simple_user_model.dart';
import 'package:yconic/data/models/user_model.dart';
import 'package:yconic/domain/entities/public_user_profile.dart';
import 'package:yconic/domain/entities/simple_user.dart';
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

  @override
  Future<User> updateUserAccount(String id, UpdateUserAccountDto dto) async {
    final response = await client.patch(
        Uri.parse('$baseUrl/User/account-info/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final userModel = UserModel.fromJson(userJson);
      return userModel.toEntity();
    } else {
      throw Exception('Updation failed');
    }
  }

  @override
  Future<User> updateUserPersonal(String id, UpdateUserPersonalDto dto) async {
    final response = await client.patch(
        Uri.parse('$baseUrl/User/personal-info/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final userModel = UserModel.fromJson(userJson);
      return userModel.toEntity();
    } else {
      throw Exception('Updation failed');
    }
  }

  @override
  Future<void> changePassword(String id, ChangePasswordDto dto) async {
    final response = await client.patch(
        Uri.parse('$baseUrl/User/change-password/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Password change process failed');
    }
  }

  @override
  Future<User> changePrivacy(String id) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/User/change-privacy/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final userModel = UserModel.fromJson(userJson);
      return userModel.toEntity();
    } else {
      throw Exception('Privacy change process failed');
    }
  }

  @override
  Future<User> changeProfilePhoto(String url, ChangeProfilePhotoDto dto) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    var multipartFile = await http.MultipartFile.fromPath(
      'photo',
      dto.photo.path,
    );
    request.files.add(multipartFile);

    http.StreamedResponse streamedResponse = await request.send();

    final responseString = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(responseString);
      final userJson = data['data'];
      final userModel = UserModel.fromJson(userJson);
      return userModel.toEntity();
    } else {
      throw Exception('Photo add process failed');
    }
  }

  @override
  Future<PublicUserProfile> getPublicUserProfile(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/User/$userId/public-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return PublicUserProfileModel.fromJson(data).toEntity();
    } else {
      throw Exception('Kullanıcı profili alınamadı');
    }
  }

  @override
  Future<List<SimpleUser>> getAllUsers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/User/simple'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data
          .map((json) => SimpleUserModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  @override
  Future<void> sendFollowRequest(
      String requesterId, String targetUserId) async {
    final response = await client.post(
      Uri.parse(
          '$baseUrl/FollowRequest/$requesterId/sendRequest/$targetUserId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Send follow request failed');
    }
  }

  @override
  Future<void> acceptFollowRequest(
      String targetUserId, String requesterId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/FollowRequest/$targetUserId/approve/$requesterId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Accept follow request failed');
    }
  }

  @override
  Future<void> declineFollowRequest(
      String targetUserId, String requesterId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/FollowRequest/$targetUserId/reject/$requesterId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Decline follow request failed');
    }
  }

  @override
  Future<void> cancelFollowRequest(
      String requesterId, String targetUserId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/FollowRequest/$requesterId/cancel/$targetUserId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Decline follow request failed');
    }
  }

  @override
  Future<void> followUser(String followerId, String followedId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Follow/$followerId/follow/$followedId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Follow request failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> unfollowUser(String followerId, String followedId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/Follow/$followerId/unfollow/$followedId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Unfollow request failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> removeFollower(String followerId, String followedId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/Follow/$followerId/unfollow/$followedId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokenService.getToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Unfollow request failed: ${response.statusCode}');
    }
  }
}
