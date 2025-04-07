import 'package:yconic/data/mappers/clothe_category_model_mapper.dart';
import 'package:yconic/data/models/garderobe_model.dart';
import 'package:yconic/domain/entities/garderobe.dart';

extension GarderobeModelMapper on GarderobeModel {
  Garderobe toEntity() {
    return Garderobe(
      Id: id,
      Name: name,
      UserId: userId,
      ClothesCategories: categories.map((s) => s.toEntity()).toList(),
    );
  }
}
