import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';

class DeleteGarderobeWithIdUsecase {
  final GarderobeRepository repository;

  DeleteGarderobeWithIdUsecase(this.repository);

  Future<Garderobe> execute(String id) async {
    return await repository.deleteGarderobeWithId(id);
  }
}
