import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';

class GetGarderobeByIdUsecase {
  final GarderobeRepository repository;

  GetGarderobeByIdUsecase(this.repository);

  Future<Garderobe> execute(String id) async {
    return await repository.getGarderobeById(id);
  }
}
