import 'package:yconic/data/dtos/clothe_category/create_clothe_category_dto.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/domain/repositories/clotheCategory_repository.dart';

class CreateClotheCategoryUsecase {
  final ClotheCategoryRepository repository;

  CreateClotheCategoryUsecase(this.repository);

  Future<ClotheCategory> execute(CreateClotheCategoryDto clotheCategory) async {
    return await repository.createClotheCategory(clotheCategory);
  }
}
