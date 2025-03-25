import 'package:yconic/domain/repositories/clotheCategory_repository.dart';

class DeleteClotheCategoryWithIdUsecase {
  final ClotheCategoryRepository repository;

  DeleteClotheCategoryWithIdUsecase(this.repository);

  Future execute(String id) async {
    await repository.deleteClotheCategoryWithId(id);
  }
}
