import 'package:yconic/data/mappers/clothePhoto_model_mapper.dart';
import 'package:yconic/data/models/clothe_model.dart';
import 'package:yconic/domain/entities/clothe.dart';

extension ClotheModelMapper on ClotheModel {
  Clothe toEntity() {
    return Clothe(
        Id: id,
        Brand: brand,
        Name: name,
        MainPhoto: mainPhoto,
        CategoryId: categoryId,
        ClothePhotos: photos.map((s) => s.toEntity()).toList());
  }
}
