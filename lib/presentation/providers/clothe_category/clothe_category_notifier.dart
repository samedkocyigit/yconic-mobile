import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/dtos/clothe_category/create_clothe_category_dto.dart';
import 'package:yconic/data/dtos/clothe_category/update_clothe_category_dto.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/createClotheCategory_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/deleteClotheCategoryWithId_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/getClotheCategoryById_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/updateClotheCategory_usecase.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_state.dart';

class ClotheCategoryNotifier extends StateNotifier<ClotheCategoryState> {
  final Ref ref;
  final CreateClotheCategoryUsecase createClotheCategoryUsecase;
  final UpdateClotheCategoryUsecase updateClotheCategoryUsecase;
  final DeleteClotheCategoryWithIdUsecase deleteClotheCategoryWithIdUsecase;
  final GetClotheCategoryByIdUsecase getClotheCategoryByIdUsecase;

  ClotheCategoryNotifier(
      {required this.ref,
      required this.createClotheCategoryUsecase,
      required this.updateClotheCategoryUsecase,
      required this.deleteClotheCategoryWithIdUsecase,
      required this.getClotheCategoryByIdUsecase})
      : super(ClotheCategoryState());

  Future<void> createClotheCategory(CreateClotheCategoryDto category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdCategory =
          await createClotheCategoryUsecase.execute(category);
      state = state.copyWith(isLoading: false, category: createdCategory);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateClotheCategory(UpdateClotheCategoryDto category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedCategory =
          await updateClotheCategoryUsecase.execute(category);
      state = state.copyWith(isLoading: false, category: updatedCategory);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteClotheCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteClotheCategoryWithIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, category: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fetchedCategory = await getClotheCategoryByIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, category: fetchedCategory);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
