import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
import 'package:yconic/data/mappers/clothePhoto_model_mapper.dart';
import 'package:yconic/data/models/clothePhoto_model.dart'
    show ClothePhotoModel;
import 'package:yconic/domain/entities/clothePhoto.dart' show ClothePhoto;
import 'package:yconic/domain/repositories/clothePhoto_repository.dart';

class ClothePhotoRepositoryImpl implements ClothePhotoRepository {
  final String baseUrl;
  final http.Client client;

  ClothePhotoRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<ClothePhoto> getClothePhotoById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/clothePhoto/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final clothePhotoModel = ClothePhotoModel.fromJson(data);
      return clothePhotoModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<ClothePhoto> updateClothePhoto(ClothePhoto clothePhoto) async {
    final response = await client.put(Uri.parse('$baseUrl/clothePhoto'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clothePhoto.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final clothePhotoModel = ClothePhotoModel.fromJson(data);
      return clothePhotoModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future deleteClothePhotoWithId(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/clothePhoto/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
