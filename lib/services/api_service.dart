import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'http://localhost:5169/api';
  String? token;

  ApiService() {
    _dio.options.baseUrl = baseUrl;
  }

  void setToken(String newToken) {
    token = newToken;
  }

  Future<Response> getCategories() async {
    return await _dio.get('/categories');
  }

  Future<Response> getClothes(int? categoryId) async {
    String endpoint = '/clothes';
    if (categoryId != null) {
      endpoint += '?categoryId=$categoryId';
    }
    return await _dio.get(endpoint);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedResponse['isSuccess'] == true) {
        return {
          'token': decodedResponse['data']['token'],
          'user': decodedResponse['data']['user'],
        };
      } else {
        throw Exception(
            decodedResponse['errors']?.join(', ') ?? 'Giriş başarısız');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String surname, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'surname': surname,
          'email': email,
          'password': password,
        }),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 201 && decodedResponse['isSuccess'] == true) {
        return decodedResponse['data'];
      } else {
        throw Exception(
            decodedResponse['errors']?.join(', ') ?? 'Kayıt başarısız');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<Map<String, dynamic>> addClothe({
    required String name,
    required String brand,
    required String categoryId,
    required String photoPath,
    String? description,
  }) async {
    try {
      final photoFile = File(photoPath);
      final photoBytes = await photoFile.readAsBytes();
      final photoBase64 = base64Encode(photoBytes);

      final response = await http.post(
        Uri.parse('$baseUrl/clothes'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'brand': brand,
          'description': description,
          'categoryId': categoryId,
          'photo': photoBase64,
        }),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 201 && decodedResponse['isSuccess'] == true) {
        return decodedResponse['data'];
      } else {
        throw Exception(
            decodedResponse['errors']?.join(', ') ?? 'Kıyafet eklenemedi');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<void> deleteClothe(String clotheId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/clothes/$clotheId'),
        headers: _getHeaders(includeContentType: false),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode != 200 || decodedResponse['isSuccess'] != true) {
        throw Exception(
            decodedResponse['errors']?.join(', ') ?? 'Kıyafet silinemedi');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<Map<String, dynamic>> updateClothe({
    required String clotheId,
    String? name,
    String? brand,
    String? description,
    String? photoPath,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (brand != null) updateData['brand'] = brand;
      if (description != null) updateData['description'] = description;

      if (photoPath != null) {
        final photoFile = File(photoPath);
        final photoBytes = await photoFile.readAsBytes();
        final photoBase64 = base64Encode(photoBytes);
        updateData['photo'] = photoBase64;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/clothes/$clotheId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['isSuccess'] == true) {
          return decodedResponse['data'];
        } else {
          throw Exception(decodedResponse['errors']?.join(', ') ??
              'Kıyafet güncellenemedi');
        }
      } else {
        throw Exception('Kıyafet güncellenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<Map<String, dynamic>> addCategory({
    required String name,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['isSuccess'] == true) {
          return decodedResponse['data'];
        } else {
          throw Exception(
              decodedResponse['errors']?.join(', ') ?? 'Kategori eklenemedi');
        }
      } else {
        throw Exception('Kategori eklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<Map<String, dynamic>> refreshGarderobeData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/garderobe'),
        headers: _getHeaders(includeContentType: false),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedResponse['isSuccess'] == true) {
        return decodedResponse['data'];
      } else {
        throw Exception(decodedResponse['errors']?.join(', ') ??
            'Gardırop verileri alınamadı');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  // Token kontrolü için yardımcı metod
  void _checkToken() {
    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }
  }

  // API çağrıları için ortak header oluşturan yardımcı metod
  Map<String, String> _getHeaders({bool includeContentType = true}) {
    _checkToken();
    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };
    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }
}

// ApiService provider'ı
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Authenticated API Service provider'ı
// Bu provider, token'ı olan bir ApiService instance'ı döndürür
final authenticatedApiServiceProvider = Provider<ApiService>((ref) {
  final authState = ref.watch(authProvider);
  final apiService = ref.watch(apiServiceProvider);

  if (authState.token != null) {
    apiService.setToken(authState.token!);
  }

  return apiService;
});
