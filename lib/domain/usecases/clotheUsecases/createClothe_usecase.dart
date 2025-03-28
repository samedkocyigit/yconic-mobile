import 'package:yconic/data/dtos/create_clothe_dto.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class CreateClotheUsecase {
  final ClotheRepository repository;

  CreateClotheUsecase(this.repository);

  Future execute(CreateClotheDto clothe) async {
    await repository.createClothe(clothe);
  }
}
