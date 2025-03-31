import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
import 'package:yconic/data/dtos/clothe/create_clothe_dto.dart';
import 'package:yconic/data/dtos/clothe/patch_clothe_request_dto.dart';
import 'package:yconic/data/mappers/clothe_model_mapper.dart';
import 'package:yconic/data/models/clothe_model.dart' show ClotheModel;
import 'package:yconic/domain/entities/clothe.dart' show Clothe;
import 'package:yconic/domain/repositories/clothe_repository.dart';

class ClotheRepositoryImpl implements ClotheRepository {
  final String baseUrl;
  final http.Client client;

  ClotheRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Clothe> getClotheById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/clothe/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final clotheModel = ClotheModel.fromJson(userJson);
      return clotheModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<Clothe> updateClothe(String id, PatchClotheRequestDto clothe) async {
    final response = await client.patch(Uri.parse('$baseUrl/Clothe/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clothe.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];

      final clotheModel = ClotheModel.fromJson(userJson);
      return clotheModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> createClothe(CreateClotheDto clothe) async {
    final uri = Uri.parse('$baseUrl/Clothe');

    final request = http.MultipartRequest('POST', uri)
      ..fields.addAll(clothe.toFields());

    for (final photo in clothe.photoFiles) {
      final multipartFile =
          await http.MultipartFile.fromPath('Photos', photo.path);
      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
          'Creation failed: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future deleteClotheWithId(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/clothe/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
