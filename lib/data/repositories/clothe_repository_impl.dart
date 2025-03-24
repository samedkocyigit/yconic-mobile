import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
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
      final clotheModel = ClotheModel.fromJson(data);
      return clotheModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<Clothe> updateClothe(Clothe clothe) async {
    final response = await client.put(Uri.parse('$baseUrl/clothe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clothe.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final clotheModel = ClotheModel.fromJson(data);
      return clotheModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future createClothe(Clothe clothe) async {
    final response = await client.post(Uri.parse('$baseUrl/clothe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clothe.toJson()));

    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'Creation process has been failed: ${response.statusCode}');
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
