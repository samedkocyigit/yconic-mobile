import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/presentation/providers/clothe_category_provider.dart';

final clotheProvider = Provider<List<Clothe>>((ref) {
  final categories = ref.watch(clothesCategoryProvider);
  return categories
      .expand((category) => category.Clothes ?? [])
      .cast<Clothe>()
      .toList();
});
