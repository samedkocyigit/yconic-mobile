import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
import 'package:yconic/data/dtos/clothe_photos/create_clothe_photos.dto.dart';
import 'package:yconic/data/mappers/clothe_photo_model_mapper.dart';
import 'package:yconic/data/models/clothe_photo_model.dart'
    show ClothePhotoModel;
import 'package:yconic/domain/entities/clothe_photo.dart' show ClothePhoto;
import 'package:yconic/domain/repositories/clothe_photo_repository.dart';

class ClothePhotoRepositoryImpl implements ClothePhotoRepository {
  final String baseUrl;
  final http.Client client;

  ClothePhotoRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  @override
  Future<List<ClothePhoto>> createClothePhoto(CreateClothePhotoDto dto) async {
    final uri = Uri.parse('$baseUrl/ClothePhoto/${dto.clotheId}');
    final request = http.MultipartRequest('POST', uri);

    request.fields['clotheId'] = dto.clotheId;

    for (var file in dto.photoFiles) {
      request.files.add(await http.MultipartFile.fromPath('photos', file.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ClothePhotoModel.fromJson(e).toEntity()).toList();
    } else {
      throw Exception('Photo upload failed: ${response.statusCode}');
    }
  }

  @override
  Future deleteClothePhotoWithId(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/ClothePhoto/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
