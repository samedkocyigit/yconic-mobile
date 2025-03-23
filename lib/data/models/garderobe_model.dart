import 'package:yconic/data/models/clotheCategory_model.dart';

class GarderobeModel {
  final String id;
  final String name;
  final String userId;
  final List<CategoryModel> clothesCategory;

  GarderobeModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.clothesCategory,
  });

  factory GarderobeModel.fromJson(Map<String, dynamic> json) {
    return GarderobeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      clothesCategory: (json['clothesCategory'] as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
