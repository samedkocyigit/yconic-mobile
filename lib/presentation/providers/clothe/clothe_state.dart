import 'package:yconic/domain/entities/clothe.dart';

class ClotheState {
  final bool isLoading;
  final Clothe? clothe;
  final String? error;

  ClotheState({this.isLoading = false, this.clothe, this.error});

  ClotheState copyWith({
    bool? isLoading,
    Clothe? clothe,
    String? error,
  }) {
    return ClotheState(
      isLoading: isLoading ?? this.isLoading,
      clothe: clothe ?? this.clothe,
      error: error,
    );
  }

  factory ClotheState.initial() {
    return ClotheState(isLoading: false, error: null, clothe: null);
  }
}
