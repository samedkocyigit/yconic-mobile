import 'package:yconic/data/dtos/clothe_category/update_clothe_category_dto.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/domain/repositories/clotheCategory_repository.dart';

class UpdateClotheCategoryUsecase {
  final ClotheCategoryRepository repository;

  UpdateClotheCategoryUsecase(this.repository);

  Future<ClotheCategory> execute(UpdateClotheCategoryDto clothePhoto) async {
    return await repository.updateClotheCategory(clothePhoto);
  }
}
