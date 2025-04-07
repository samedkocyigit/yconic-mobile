import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/dtos/clothe/create_clothe_dto.dart';
import 'package:yconic/data/dtos/clothe/patch_clothe_request_dto.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/usecases/clotheUsecases/create_clothe_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/delete_clothe_with_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/get_clothe_by_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/update_clothe_usecase.dart';
import 'package:yconic/presentation/providers/clothe/clothe_state.dart';

class ClotheNotifier extends StateNotifier<ClotheState> {
  final Ref ref;
  final CreateClotheUsecase createClotheUsecase;
  final UpdateClotheUsecase updateClotheUsecase;
  final DeleteClotheWithIdUsecase deleteClotheWithIdUsecase;
  final GetClotheByIdUsecase getClotheByIdUsecase;

  ClotheNotifier({
    required this.ref,
    required this.createClotheUsecase,
    required this.updateClotheUsecase,
    required this.deleteClotheWithIdUsecase,
    required this.getClotheByIdUsecase,
  }) : super(ClotheState());

  Future<void> createClothe(CreateClotheDto clothe) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newClothe = await createClotheUsecase.execute(clothe);
      state = state.copyWith(isLoading: false, clothe: newClothe);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateClothe(String id, PatchClotheRequestDto clotheDto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedClothe = await updateClotheUsecase.execute(id, clotheDto);
      state = state.copyWith(isLoading: false, clothe: updatedClothe);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteClothe(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteClotheWithIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, clothe: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Clothe> getClothe(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fetchedClothe = await getClotheByIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, clothe: fetchedClothe);
      return fetchedClothe;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}
