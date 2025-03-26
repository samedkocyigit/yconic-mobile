import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/presentation/providers/user_provider.dart';

final clothesCategoryProvider = Provider<List<ClotheCategory>>((ref) {
  final user = ref.watch(userProvider);
  return user?.UserGarderobe?.ClothesCategories ?? [];
});
