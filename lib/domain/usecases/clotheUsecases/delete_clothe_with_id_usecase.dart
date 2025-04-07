import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class DeleteClotheWithIdUsecase {
  final ClotheRepository repository;

  DeleteClotheWithIdUsecase(this.repository);

  Future<Clothe> execute(String id) async {
    return await repository.deleteClotheWithId(id);
  }
}
