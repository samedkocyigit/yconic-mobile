import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/delete_garderobe_with_id_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/get_garderobe_by_id_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/update_garderobe_usecase.dart';
import 'package:yconic/presentation/providers/garderobe/garderobe_state.dart';

class GarderobeNotifier extends StateNotifier<GarderobeState> {
  final Ref ref;
  final UpdateGarderobeUsecase updateGarderobeUsecase;
  final DeleteGarderobeWithIdUsecase deleteGarderobeWithIdUsecase;
  final GetGarderobeByIdUsecase getGarderobeByIdUsecase;

  GarderobeNotifier(
      {required this.ref,
      required this.updateGarderobeUsecase,
      required this.deleteGarderobeWithIdUsecase,
      required this.getGarderobeByIdUsecase})
      : super(GarderobeState());

  Future<void> updateGarderobe(Garderobe garderobe) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedGarderobe = await updateGarderobeUsecase.execute(garderobe);
      state = state.copyWith(isLoading: false, garderobe: updatedGarderobe);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteGarderobe(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteGarderobeWithIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, garderobe: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getGarderobe(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fetchedGarderobe = await getGarderobeByIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, garderobe: fetchedGarderobe);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
