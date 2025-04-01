import 'package:yconic/data/models/clotheCategory_model.dart';

class GarderobeModel {
  final String id;
  final String? name;
  final String userId;
  final List<ClotheCategoryModel> categories;

  GarderobeModel({
    required this.id,
    this.name,
    required this.userId,
    required this.categories,
  });

  factory GarderobeModel.fromJson(Map<String, dynamic> json) {
    return GarderobeModel(
      id: json['id'] as String,
      name: json['name'] != null ? json['name'] as String : 'My Garderobe',
      userId: json['userId'] as String,
      categories: (json['categories'] as List)
          .map((e) => ClotheCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
