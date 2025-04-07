import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/clothe_category.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_notifier.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_state.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

final clotheCategoriesProvider = Provider<List<ClotheCategory>>((ref) {
  final user = ref.watch(userProvider);
  return user?.UserGarderobe?.ClothesCategories ?? [];
});

final clotheCategoryNotifierProvider =
    StateNotifierProvider<ClotheCategoryNotifier, ClotheCategoryState>((ref) {
  final createClotheCategoryUseCase =
      ref.watch(createClotheCategoryUseCaseProvider);
  final updateClotheCategoryUseCase =
      ref.watch(updateClotheCategoryUseCaseProvider);
  final deleteClotheCategoryWithIdUseCase =
      ref.watch(deleteClotheCategoryWithIdUseCaseProvider);
  final getClotheCategoryByIdUseCase =
      ref.watch(getClotheCategoryByIdUseCaseProvider);

  return ClotheCategoryNotifier(
      ref: ref,
      createClotheCategoryUsecase: createClotheCategoryUseCase,
      updateClotheCategoryUsecase: updateClotheCategoryUseCase,
      deleteClotheCategoryWithIdUsecase: deleteClotheCategoryWithIdUseCase,
      getClotheCategoryByIdUsecase: getClotheCategoryByIdUseCase);
});
