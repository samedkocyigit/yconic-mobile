import 'package:yconic/data/dtos/create_clothe_photos.dto.dart';
import 'package:yconic/domain/entities/clothePhoto.dart';
import 'package:yconic/domain/repositories/clothePhoto_repository.dart';

class CreateClothePhotoUsecase {
  final ClothePhotoRepository repository;

  CreateClothePhotoUsecase(this.repository);

  Future<List<ClothePhoto>> execute(CreateClothePhotoDto clothePhoto) async {
    return await repository.createClothePhoto(clothePhoto);
  }
}
