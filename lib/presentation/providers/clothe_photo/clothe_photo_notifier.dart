import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/dtos/clothe_photos/create_clothe_photos.dto.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/createClothePhoto_usecase.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/deleteClothePhotoWithId_usecase.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_state.dart';

class ClothePhotoNotifier extends StateNotifier<ClothePhotoState> {
  final Ref ref;
  final CreateClothePhotoUsecase createClothePhotoUsecase;
  final DeleteClothePhotoWithIdUsecase deleteClothePhotoWithIdUsecase;

  ClothePhotoNotifier({
    required this.ref,
    required this.createClothePhotoUsecase,
    required this.deleteClothePhotoWithIdUsecase,
  }) : super(ClothePhotoState());

  Future<void> createClothePhoto(CreateClothePhotoDto clothePhoto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newClothePhoto =
          await createClothePhotoUsecase.execute(clothePhoto);
      state = state.copyWith(isLoading: false, clothePhoto: newClothePhoto);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteClothePhoto(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteClothePhotoWithIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, clothePhoto: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
