import 'package:yconic/domain/entities/clotheCategory.dart';

class Garderobe {
  final String Id;
  final String Name;
  final String UserId;
  final List<ClotheCategory> ClothesCategories;

  Garderobe(
      {required this.Id,
      required this.Name,
      required this.UserId,
      required this.ClothesCategories});

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'name': Name,
      'userId': UserId,
      'clothesCategories': ClothesCategories,
    };
  }
}
