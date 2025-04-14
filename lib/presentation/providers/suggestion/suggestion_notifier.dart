import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/usecases/suggestionUsecases/create_suggestion_usecase.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/suggestion/suggestion_state.dart';

class SuggestionNotifier extends StateNotifier<SuggestionState> {
  final Ref ref;
  final CreateSuggestionUsecase createSuggestionUsecase;

  SuggestionNotifier({required this.ref, required this.createSuggestionUsecase})
      : super(SuggestionState());

  Future<void> createSuggestion(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newSuggestion = await createSuggestionUsecase.execute(userId);
      state = state.copyWith(isLoading: false, suggestion: newSuggestion);
      ref.read(authNotifierProvider.notifier).addSuggestion(newSuggestion);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
