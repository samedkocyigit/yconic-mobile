import 'package:yconic/domain/entities/clothePhoto.dart';

abstract class ClothePhotoRepository {
  Future<ClothePhoto> getClothePhotoById(String id);
  Future<ClothePhoto> updateClothePhoto(ClothePhoto clothePhoto);
  Future deleteClothePhotoWithId(String id);
}
