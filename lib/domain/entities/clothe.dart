import 'package:yconic/domain/entities/clothePhoto.dart';

class Clothe {
  final String Id;
  final String Brand;
  final String Name;
  final String? Description;
  final String MainPhoto;
  final String CategoryId;
  final List<ClothePhoto> ClothePhotos;

  Clothe(
      {required this.Id,
      required this.Brand,
      required this.Name,
      required this.MainPhoto,
      required this.CategoryId,
      required this.ClothePhotos,
      this.Description});

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'brand': Brand,
      'name': Name,
      'description': Description,
      'mainPhoto': MainPhoto,
      'categoryId': CategoryId,
      'clothePhotos': ClothePhotos,
    };
  }
}
