import 'package:yconic/domain/entities/clothePhoto.dart';
import 'package:yconic/domain/repositories/clothePhoto_repository.dart';

class UpdateClothePhotoUsecase {
  final ClothePhotoRepository repository;

  UpdateClothePhotoUsecase(this.repository);

  Future<ClothePhoto> execute(ClothePhoto clothePhoto) async {
    return await repository.updateClothePhoto(clothePhoto);
  }
}
