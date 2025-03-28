import 'package:yconic/domain/entities/clothePhoto.dart';

class Clothe {
  final String Id;
  final String Brand;
  final String Name;
  final String? Description;
  final String MainPhoto;
  final String CategoryId;
  final List<ClothePhoto>? ClothePhotos;

  Clothe(
      {required this.Id,
      required this.Brand,
      required this.Name,
      required this.MainPhoto,
      required this.CategoryId,
      this.ClothePhotos,
      this.Description});

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'brand': Brand,
      'name': Name,
      'description': Description,
      'mainPhoto': MainPhoto,
      'categoryId': CategoryId,
      'photos': ClothePhotos,
    };
  }

  Clothe copyWith({
    String? Id,
    String? Brand,
    String? Name,
    String? Description,
    String? MainPhoto,
    String? CategoryId,
    List<ClothePhoto>? ClothePhotos,
  }) {
    return Clothe(
      Id: Id ?? this.Id,
      Brand: Brand ?? this.Brand,
      Name: Name ?? this.Name,
      Description: Description ?? this.Description,
      MainPhoto: MainPhoto ?? this.MainPhoto,
      CategoryId: CategoryId ?? this.CategoryId,
      ClothePhotos: ClothePhotos ?? this.ClothePhotos,
    );
  }
}
