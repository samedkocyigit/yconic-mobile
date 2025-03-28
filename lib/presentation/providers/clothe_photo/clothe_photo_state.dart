import 'package:yconic/domain/entities/clothePhoto.dart';

class ClothePhotoState {
  final bool isLoading;
  final List<ClothePhoto?> clothePhoto;
  final String? error;

  ClothePhotoState({
    this.isLoading = false,
    this.clothePhoto = const [],
    this.error,
  });

  ClothePhotoState copyWith({
    bool? isLoading,
    List<ClothePhoto?>? clothePhoto,
    String? error,
  }) {
    return ClothePhotoState(
      isLoading: isLoading ?? this.isLoading,
      clothePhoto: clothePhoto ?? this.clothePhoto,
      error: error,
    );
  }

  factory ClothePhotoState.initial() {
    return ClothePhotoState();
  }
}
