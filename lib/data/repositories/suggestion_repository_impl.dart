import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yconic/data/mappers/suggestion_model_mapper.dart';
import 'package:yconic/data/models/suggestion_model.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/repositories/suggestion_repository.dart';

class SuggestionRepositoryImpl implements SuggestionRepository {
  final String baseUrl;
  final http.Client client;

  SuggestionRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Suggestion> getSuggestionById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/suggestion/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final suggestionModel = SuggestionModel.fromJson(userJson);
      return suggestionModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<Suggestion> createSuggestion(String userId) async {
    final response = await client.post(Uri.parse('$baseUrl/suggestion/$userId'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final suggestionModel = SuggestionModel.fromJson(userJson);
      return suggestionModel.toEntity();
    } else {
      throw Exception(
          'Creation process has been failed: ${response.statusCode}');
    }
  }
}
