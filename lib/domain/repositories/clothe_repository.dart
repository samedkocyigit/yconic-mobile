import 'package:yconic/domain/entities/clothe.dart';

abstract class ClotheRepository {
  Future<Clothe> getClotheById(String id);
  Future<Clothe> updateClothe(Clothe clothe);
  Future createClothe(Clothe clothe);
  Future deleteClotheWithId(String id);
}
