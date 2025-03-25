import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class CreateClotheUsecase {
  final ClotheRepository repository;

  CreateClotheUsecase(this.repository);

  Future execute(Clothe clothe) async {
    await repository.createClothe(clothe);
  }
}
