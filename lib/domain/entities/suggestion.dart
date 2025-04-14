import 'package:yconic/domain/entities/clothe.dart';

class Suggestion {
  final String Id;
  final String UserId;
  final String? Description;
  final String? Image;
  // final DateTime? CreatedAt;
  final List<Clothe> SuggestedLook;

  Suggestion(
      {required this.Id,
      required this.UserId,
      this.Description,
      this.Image,
      // required this.CreatedAt,
      required this.SuggestedLook});
}
