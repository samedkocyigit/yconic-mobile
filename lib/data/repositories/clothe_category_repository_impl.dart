import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;
import 'package:yconic/data/dtos/clothe_category/create_clothe_category_dto.dart';
import 'package:yconic/data/dtos/clothe_category/update_clothe_category_dto.dart';
import 'package:yconic/data/mappers/clothe_category_model_mapper.dart';
import 'package:yconic/data/models/clothe_category_model.dart'
    show ClotheCategoryModel;
import 'package:yconic/domain/entities/clothe_category.dart'
    show ClotheCategory;
import 'package:yconic/domain/repositories/clothe_category_repository.dart';

class ClotheCategoryRepositoryImpl implements ClotheCategoryRepository {
  final String baseUrl;
  final http.Client client;

  ClotheCategoryRepositoryImpl({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<ClotheCategory> getClotheCategoryById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/clotheCategory/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final clotheCategoryModel = ClotheCategoryModel.fromJson(userJson);
      return clotheCategoryModel.toEntity();
    } else {
      throw Exception(
          'Fetching operation has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<ClotheCategory> updateClotheCategory(
      UpdateClotheCategoryDto clotheCategory) async {
    final response = await client.patch(
        Uri.parse('$baseUrl/ClotheCategory/${clotheCategory.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clotheCategory.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final clotheCategoryModel = ClotheCategoryModel.fromJson(userJson);
      return clotheCategoryModel.toEntity();
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future<ClotheCategory> createClotheCategory(
      CreateClotheCategoryDto clotheCategory) async {
    final response = await client.post(Uri.parse('$baseUrl/clotheCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clotheCategory.toJson()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userJson = data['data'];
      final clotheCategoryModel = ClotheCategoryModel.fromJson(userJson);
      return clotheCategoryModel.toEntity();
    } else {
      throw Exception(
          'Creation process has been failed: ${response.statusCode}');
    }
  }

  @override
  Future deleteClotheCategoryWithId(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/clotheCategory/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Update process has been failed: ${response.statusCode}');
    }
  }
}
