import 'package:yconic/data/dtos/create_clothe_dto.dart';
import 'package:yconic/domain/entities/clothe.dart';

abstract class ClotheRepository {
  Future<Clothe> getClotheById(String id);
  Future<Clothe> updateClothe(Clothe clothe);
  Future createClothe(CreateClotheDto clothe);
  Future deleteClotheWithId(String id);
}
