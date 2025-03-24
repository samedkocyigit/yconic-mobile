import 'package:yconic/data/mappers/clotheCategory_model_mapper.dart';
import 'package:yconic/data/models/garderobe_model.dart';
import 'package:yconic/domain/entities/garderobe.dart';

extension GarderobeModelMapper on GarderobeModel {
  Garderobe toEntity() {
    return Garderobe(
      Id: id,
      Name: name,
      UserId: userId,
      ClothesCategories: clothesCategory.map((s) => s.toEntity()).toList(),
    );
  }
}
