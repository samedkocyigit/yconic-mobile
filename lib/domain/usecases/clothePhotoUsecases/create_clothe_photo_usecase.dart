import 'package:yconic/data/dtos/clothe_photos/create_clothe_photos.dto.dart';
import 'package:yconic/domain/entities/clothe_photo.dart';
import 'package:yconic/domain/repositories/clothe_photo_repository.dart';

class CreateClothePhotoUsecase {
  final ClothePhotoRepository repository;

  CreateClothePhotoUsecase(this.repository);

  Future<List<ClothePhoto>> execute(CreateClothePhotoDto clothePhoto) async {
    return await repository.createClothePhoto(clothePhoto);
  }
}
