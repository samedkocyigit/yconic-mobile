import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/suggestion/suggestion_notifier.dart';
import 'package:yconic/presentation/providers/suggestion/suggestion_state.dart';
import 'package:yconic/presentation/providers/app_providers.dart';

final suggestionProvider =
    StateNotifierProvider<SuggestionNotifier, SuggestionState>((ref) {
  final usecase = ref.watch(createSuggestionUsecaseProvider);
  return SuggestionNotifier(ref: ref, createSuggestionUsecase: usecase);
});
