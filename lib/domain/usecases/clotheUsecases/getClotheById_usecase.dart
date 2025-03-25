import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';

class GetClotheByIdUsecase {
  final ClotheRepository repository;

  GetClotheByIdUsecase(this.repository);

  Future<Clothe> execute(String id) async {
    return await repository.getClotheById(id);
  }
}
