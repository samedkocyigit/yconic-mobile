import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/repositories/suggestion_repository.dart';

class CreateSuggestionUsecase {
  final SuggestionRepository repository;

  CreateSuggestionUsecase(this.repository);

  Future<Suggestion> execute(String userId) async {
    return await repository.createSuggestion(userId);
  }
}
