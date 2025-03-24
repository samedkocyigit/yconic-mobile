import 'package:yconic/data/mappers/clothe_model_mapper.dart';
import 'package:yconic/data/models/clotheCategory_model.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';

extension ClothecategoryModelMapper on ClotheCategoryModel {
  ClotheCategory toEntity() {
    return ClotheCategory(
        Id: id,
        CategoryType: categoryType,
        Clothes: clothes.map((s) => s.toEntity()).toList(),
        GarderobeId: garderobeId,
        Name: name);
  }
}
