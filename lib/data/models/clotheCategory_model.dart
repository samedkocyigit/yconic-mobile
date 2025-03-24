import 'package:yconic/data/models/clothe_model.dart';

class ClotheCategoryModel {
  final String id;
  final String name;
  final int categoryType;
  final String garderobeId;
  final List<ClotheModel> clothes;

  ClotheCategoryModel({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.garderobeId,
    required this.clothes,
  });

  factory ClotheCategoryModel.fromJson(Map<String, dynamic> json) {
    return ClotheCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryType: json['categoryType'] as int,
      garderobeId: json['garderobeId'] as String,
      clothes: (json['clothes'] as List)
          .map((e) => ClotheModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
