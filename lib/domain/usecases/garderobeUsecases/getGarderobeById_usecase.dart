import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';

class GetgarderobeByIdUsecase {
  final GarderobeRepository repository;

  GetgarderobeByIdUsecase(this.repository);

  Future<Garderobe> execute(String id) async {
    return await repository.getGarderobeById(id);
  }
}
