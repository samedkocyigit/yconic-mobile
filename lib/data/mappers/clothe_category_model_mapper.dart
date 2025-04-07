import 'package:yconic/data/mappers/clothe_model_mapper.dart';
import 'package:yconic/data/models/clothe_category_model.dart';
import 'package:yconic/domain/entities/clothe_category.dart';

extension ClotheCategoryModelMapper on ClotheCategoryModel {
  ClotheCategory toEntity() {
    return ClotheCategory(
        Id: id,
        CategoryType: categoryType,
        Clothes: clothes.map((s) => s.toEntity()).toList(),
        GarderobeId: garderobeId,
        Name: name);
  }
}
