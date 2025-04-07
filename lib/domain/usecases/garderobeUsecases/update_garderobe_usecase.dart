import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';

class UpdateGarderobeUsecase {
  final GarderobeRepository repository;

  UpdateGarderobeUsecase(this.repository);

  Future<Garderobe> execute(Garderobe garderobe) async {
    return await repository.updateGarderobe(garderobe);
  }
}
