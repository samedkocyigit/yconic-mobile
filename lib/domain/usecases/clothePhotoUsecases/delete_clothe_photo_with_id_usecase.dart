import 'package:yconic/domain/repositories/clothe_photo_repository.dart';

class DeleteClothePhotoWithIdUsecase {
  final ClothePhotoRepository repository;

  DeleteClothePhotoWithIdUsecase(this.repository);

  Future execute(String id) async {
    await repository.deleteClothePhotoWithId(id);
  }
}
