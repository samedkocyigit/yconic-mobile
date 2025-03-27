import 'package:yconic/domain/entities/clotheCategory.dart';

class ClotheCategoryState {
  final bool isLoading;
  final ClotheCategory? category;
  final String? error;

  ClotheCategoryState({this.isLoading = false, this.category, this.error});

  ClotheCategoryState copyWith({
    bool? isLoading,
    ClotheCategory? category,
    String? error,
  }) {
    return ClotheCategoryState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      error: error,
    );
  }

  factory ClotheCategoryState.initial() {
    return ClotheCategoryState(isLoading: false, error: null, category: null);
  }
}
