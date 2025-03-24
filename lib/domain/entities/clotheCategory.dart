import 'package:yconic/domain/entities/clothe.dart';

class ClotheCategory {
  final String Id;
  final String Name;
  final int CategoryType;
  final String GarderobeId;
  final List<Clothe> Clothes;

  ClotheCategory({
    required this.Id,
    required this.CategoryType,
    required this.Clothes,
    required this.GarderobeId,
    required this.Name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'name': Name,
      'categoryType': CategoryType,
      'garderobeId': GarderobeId,
      'clothes': Clothes
    };
  }
}
