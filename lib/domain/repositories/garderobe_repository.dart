import 'package:yconic/domain/entities/garderobe.dart';

abstract class GarderobeRepository {
  Future<Garderobe> getGarderobeById(String id);
  Future deleteGarderobeWithId(String id);
  Future<Garderobe> updateGarderobe(Garderobe garderobe);
}
