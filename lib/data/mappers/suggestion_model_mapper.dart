import 'package:yconic/data/mappers/clothe_model_mapper.dart';
import 'package:yconic/data/models/suggestion_model.dart';
import 'package:yconic/domain/entities/suggestion.dart';

extension SuggestionModelMapper on SuggestionModel {
  Suggestion toEntity() {
    return Suggestion(
      Id: id,
      UserId: userId,
      Description: description,
      // CreatedAt: DateTime.parse(createdAt),
      SuggestedLook: suggestedLook.map((s) => s.toEntity()).toList(),
    );
  }
}
