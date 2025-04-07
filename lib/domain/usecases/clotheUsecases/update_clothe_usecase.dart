import 'package:yconic/data/dtos/clothe/patch_clothe_request_dto.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class UpdateClotheUsecase {
  final ClotheRepository repository;

  UpdateClotheUsecase(this.repository);

  Future execute(String id, PatchClotheRequestDto clotheDto) async {
    await repository.updateClothe(id, clotheDto);
  }
}
