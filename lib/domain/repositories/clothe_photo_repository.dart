import 'package:yconic/data/dtos/clothe_photos/create_clothe_photos.dto.dart';
import 'package:yconic/domain/entities/clothe_photo.dart';

abstract class ClothePhotoRepository {
  Future<List<ClothePhoto>> createClothePhoto(CreateClothePhotoDto clothePhoto);
  Future deleteClothePhotoWithId(String id);
}
