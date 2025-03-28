import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/clothePhoto.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_notifier.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_state.dart';

final clothePhotoListProvider = Provider<List<ClothePhoto?>>((ref) {
  return ref.watch(clothePhotoNotifierProvider).clothePhoto;
});

final clothePhotoNotifierProvider =
    StateNotifierProvider<ClothePhotoNotifier, ClothePhotoState>((ref) {
  final createClothePhotoUseCase = ref.watch(createClothePhotoUseCaseProvider);
  final deleteClothePhotoWithIdUseCase =
      ref.watch(deleteClothePhotoWithIdUseCaseProvider);

  return ClothePhotoNotifier(
    ref: ref,
    createClothePhotoUsecase: createClothePhotoUseCase,
    deleteClothePhotoWithIdUsecase: deleteClothePhotoWithIdUseCase,
  );
});
