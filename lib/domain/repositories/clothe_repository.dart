import 'package:yconic/data/dtos/clothe/create_clothe_dto.dart';
import 'package:yconic/data/dtos/clothe/patch_clothe_request_dto.dart';
import 'package:yconic/domain/entities/clothe.dart';

abstract class ClotheRepository {
  Future<Clothe> getClotheById(String id);
  Future<Clothe> updateClothe(String id, PatchClotheRequestDto clothe);
  Future createClothe(CreateClotheDto clothe);
  Future deleteClotheWithId(String id);
}
