import 'package:yconic/domain/entities/clotheCategory.dart';

abstract class ClotheCategoryRepository {
  Future<ClotheCategory> getClotheCategoryById(String id);
  Future<ClotheCategory> createClotheCategory(ClotheCategory clotheCategory);
  Future<ClotheCategory> updateClotheCategory(ClotheCategory clotheCategory);
  Future deleteClotheCategoryWithId(String id);
}
