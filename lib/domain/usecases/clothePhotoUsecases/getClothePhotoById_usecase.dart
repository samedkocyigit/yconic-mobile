import 'package:yconic/domain/entities/clothePhoto.dart';
import 'package:yconic/domain/repositories/clothePhoto_repository.dart';

class GetClothePhotoByIdUsecase {
  final ClothePhotoRepository repository;

  GetClothePhotoByIdUsecase(this.repository);

  Future<ClothePhoto> execute(String id) async {
    return await repository.getClothePhotoById(id);
  }
}
