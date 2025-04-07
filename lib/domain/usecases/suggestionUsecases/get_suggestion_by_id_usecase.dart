import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/repositories/suggestion_repository.dart';

class GetSuggestionByIdUsecase {
  final SuggestionRepository repository;

  GetSuggestionByIdUsecase(this.repository);

  Future<Suggestion> execute(String id) async {
    return await repository.getSuggestionById(id);
  }
}
