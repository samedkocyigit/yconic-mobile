import 'package:yconic/domain/entities/clothePhoto.dart';

class Clothe{
  final String Id;
  final String Brand;
  final String Name;
  final String? Description;
  final String MainPhoto;
  final String CategoryId;
  final List<Clothephoto> ClothePhotos;

  Clothe({
    required this.Id,
    required this.Brand,
    required this.Name,
    required this.MainPhoto,
    required this.CategoryId,
    required this.ClothePhotos,
    this.Description
  });
}