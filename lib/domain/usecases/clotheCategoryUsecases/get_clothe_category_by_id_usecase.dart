import 'package:yconic/domain/entities/clothe_category.dart';
import 'package:yconic/domain/repositories/clothe_category_repository.dart';

class GetClotheCategoryByIdUsecase {
  final ClotheCategoryRepository repository;

  GetClotheCategoryByIdUsecase(this.repository);

  Future<ClotheCategory> execute(String id) async {
    return await repository.getClotheCategoryById(id);
  }
}
