import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/repositories/suggestion_repository.dart';

class GetSuggestionbyidUsecase {
  final SuggestionRepository repository;

  GetSuggestionbyidUsecase(this.repository);

  Future<Suggestion> execute(String id) async {
    return await repository.getSuggestionById(id);
  }
}
