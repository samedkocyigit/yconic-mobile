import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/garderobe/garderobe_notifier.dart';
import 'package:yconic/presentation/providers/garderobe/garderobe_state.dart';
import '../user/user_provider.dart';

final garderobeProvider = Provider<Garderobe?>((ref) {
  final user = ref.watch(userProvider);
  return user?.UserGarderobe;
});

final garderobeNotifierProvider =
    StateNotifierProvider<GarderobeNotifier, GarderobeState>((ref) {
  final updateGarderobeUseCase = ref.watch(updateGarderobeUseCaseProvider);
  final deleteGarderobeWithIdUseCase =
      ref.watch(deleteGarderobeWithIdUseCaseProvider);
  final getGarderobeByIdUseCase = ref.watch(getGarderobeByIdUseCaseProvider);

  return GarderobeNotifier(
      ref: ref,
      updateGarderobeUsecase: updateGarderobeUseCase,
      deleteGarderobeWithIdUsecase: deleteGarderobeWithIdUseCase,
      getGarderobeByIdUsecase: getGarderobeByIdUseCase);
});
