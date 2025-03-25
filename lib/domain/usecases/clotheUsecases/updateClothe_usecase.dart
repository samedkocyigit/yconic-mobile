import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class UpdateClotheUsecase {
  final ClotheRepository repository;

  UpdateClotheUsecase(this.repository);

  Future execute(Clothe clothe) async {
    await repository.updateClothe(clothe);
  }
}
