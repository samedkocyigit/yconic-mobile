import 'package:yconic/data/dtos/clothe_category/create_clothe_category_dto.dart';
import 'package:yconic/data/dtos/clothe_category/update_clothe_category_dto.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';

abstract class ClotheCategoryRepository {
  Future<ClotheCategory> getClotheCategoryById(String id);
  Future<ClotheCategory> createClotheCategory(
      CreateClotheCategoryDto clotheCategory);
  Future<ClotheCategory> updateClotheCategory(
      UpdateClotheCategoryDto clotheCategory);
  Future deleteClotheCategoryWithId(String id);
}
