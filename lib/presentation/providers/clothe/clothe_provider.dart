import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/clothe/clothe_notifier.dart';
import 'package:yconic/presentation/providers/clothe/clothe_state.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';

final clotheProvider = Provider<List<Clothe>>((ref) {
  final categories = ref.watch(clotheCategoriesProvider);
  return categories
      .expand((category) => category.Clothes ?? [])
      .cast<Clothe>()
      .toList();
});

final clotheNotifierProvider =
    StateNotifierProvider<ClotheNotifier, ClotheState>((ref) {
  final createClotheUseCase = ref.watch(createClotheUseCaseProvider);
  final updateClotheUseCase = ref.watch(updateClotheUseCaseProvider);
  final deleteClotheWithIdUseCase =
      ref.watch(deleteClotheWithIdUseCaseProvider);
  final getClotheByIdUseCase = ref.watch(getClotheByIdUseCaseProvider);

  return ClotheNotifier(
      ref: ref,
      createClotheUsecase: createClotheUseCase,
      updateClotheUsecase: updateClotheUseCase,
      deleteClotheWithIdUsecase: deleteClotheWithIdUseCase,
      getClotheByIdUsecase: getClotheByIdUseCase);
});
