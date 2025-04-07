import 'package:yconic/data/models/clothe_photo_model.dart';

class ClotheModel {
  final String id;
  final String brand;
  final String name;
  final String? description;
  final String mainPhoto;
  final String categoryId;
  final List<ClothePhotoModel> photos;

  ClotheModel({
    required this.id,
    required this.brand,
    required this.name,
    this.description,
    required this.mainPhoto,
    required this.categoryId,
    required this.photos,
  });

  factory ClotheModel.fromJson(Map<String, dynamic> json) {
    return ClotheModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      mainPhoto: json['mainPhoto'] as String,
      categoryId: json['categoryId'] as String,
      photos: (json['photos'] as List)
          .map((e) => ClothePhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
