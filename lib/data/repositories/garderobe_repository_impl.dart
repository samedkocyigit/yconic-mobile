import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
import 'package:yconic/data/mappers/garderobe_model_mapper.dart';
import 'package:yconic/data/models/garderobe_model.dart' show GarderobeModel;
import 'package:yconic/domain/entities/garderobe.dart' show Garderobe;
import 'package:yconic/domain/repositories/garderobe_repository.dart';

class GarderobeRepositoryImpl implements GarderobeRepository {
  final String baseUrl;
  final http.Client client;

  GarderobeRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Garderobe> getGarderobeById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/garderobe/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final garderobeModel = GarderobeModel.fromJson(userJson);
      return garderobeModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<Garderobe> updateGarderobe(Garderobe garderobe) async {
    final response = await client.put(Uri.parse('$baseUrl/garderobe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(garderobe.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final garderobeModel = GarderobeModel.fromJson(userJson);
      return garderobeModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future deleteGarderobeWithId(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/garderobe/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
