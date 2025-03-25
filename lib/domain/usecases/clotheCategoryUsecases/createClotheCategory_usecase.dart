import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/domain/repositories/clotheCategory_repository.dart';

class CreateClotheCategoryUsecase {
  final ClotheCategoryRepository repository;

  CreateClotheCategoryUsecase(this.repository);

  Future<ClotheCategory> execute(ClotheCategory clotheCategory) async {
    return await repository.createClotheCategory(clotheCategory);
  }
}
