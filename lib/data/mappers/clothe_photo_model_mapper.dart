import 'package:yconic/data/models/clothe_photo_model.dart';
import 'package:yconic/domain/entities/clothe_photo.dart';

extension ClothePhotoModelMapper on ClothePhotoModel {
  ClothePhoto toEntity() {
    return ClothePhoto(Id: id, Url: url, ClotheId: clotheId);
  }
}
