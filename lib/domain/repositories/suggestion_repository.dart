import 'package:yconic/domain/entities/suggestion.dart';

abstract class SuggestionRepository {
  Future<Suggestion> getSuggestionById(String id);
  Future<Suggestion> createSuggestion(String userId);
}
