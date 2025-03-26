import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/garderobe.dart';
import 'user_provider.dart';

final garderobeProvider = Provider<Garderobe?>((ref) {
  final user = ref.watch(userProvider);
  return user?.UserGarderobe;
});
