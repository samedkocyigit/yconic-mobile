import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yconic/data/mappers/persona_model_mapper.dart';
import 'package:yconic/data/models/persona_model.dart';
import 'package:yconic/domain/entities/Persona.dart';
import 'package:yconic/domain/repositories/Persona_repository.dart';

class PersonaRepositoryImpl implements PersonaRepository {
  final String baseUrl;
  final http.Client client;

  PersonaRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Persona> getPersonaById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/persona/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final personaModel = PersonaModel.fromJson(data);
      return personaModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<Persona> updatePersona(Persona persona) async {
    final response = await client.put(Uri.parse('$baseUrl/persona'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(persona.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final personaModel = PersonaModel.fromJson(data);
      return personaModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
