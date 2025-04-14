import 'package:yconic/domain/entities/suggestion.dart';

class SuggestionState {
  final bool isLoading;
  final Suggestion? suggestion;
  final String? error;

  SuggestionState({this.isLoading = false, this.suggestion, this.error});

  SuggestionState copyWith({
    bool? isLoading,
    Suggestion? suggestion,
    String? error,
  }) {
    return SuggestionState(
      isLoading: isLoading ?? this.isLoading,
      suggestion: suggestion ?? this.suggestion,
      error: error,
    );
  }

  factory SuggestionState.initial() {
    return SuggestionState(isLoading: false, error: null, suggestion: null);
  }
}
