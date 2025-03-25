import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/domain/repositories/clotheCategory_repository.dart';

class GetClotheCategoryByIdUsecase {
  final ClotheCategoryRepository repository;

  GetClotheCategoryByIdUsecase(this.repository);

  Future<ClotheCategory> execute(String id) async {
    return await repository.getClotheCategoryById(id);
  }
}
