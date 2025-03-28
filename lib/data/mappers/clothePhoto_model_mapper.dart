import 'package:yconic/data/models/clothePhoto_model.dart';
import 'package:yconic/domain/entities/clothePhoto.dart';

extension ClothephotoModelMapper on ClothePhotoModel {
  ClothePhoto toEntity() {
    return ClothePhoto(Id: id, Url: url, ClotheId: clotheId);
  }
}
