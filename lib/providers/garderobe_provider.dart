import 'package:flutter_riverpod/flutter_riverpod.dart';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class Clothe {
  final int id;
  final int categoryId;
  final String name;
  final List<String> photos;

  Clothe({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.photos,
  });
}

class GarderobeState {
  final List<Category> categories;
  final List<Clothe> clothes;
  final bool isLoading;
  final String? error;

  GarderobeState({
    this.categories = const [],
    this.clothes = const [],
    this.isLoading = false,
    this.error,
  });

  GarderobeState copyWith({
    List<Category>? categories,
    List<Clothe>? clothes,
    bool? isLoading,
    String? error,
  }) {
    return GarderobeState(
      categories: categories ?? this.categories,
      clothes: clothes ?? this.clothes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class GarderobeNotifier extends StateNotifier<GarderobeState> {
  GarderobeNotifier() : super(GarderobeState());

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true);
    try {
      // API çağrısı yapılacak
      // final categories = await api.getCategories();
      // state = state.copyWith(categories: categories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchClothes(int? categoryId) async {
    state = state.copyWith(isLoading: true);
    try {
      // API çağrısı yapılacak
      // final clothes = await api.getClothes(categoryId);
      // state = state.copyWith(clothes: clothes);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final garderobeProvider =
    StateNotifierProvider<GarderobeNotifier, GarderobeState>((ref) {
  return GarderobeNotifier();
});
