import 'package:yconic/domain/entities/clothe.dart';

class Clothecategory {
  final String Id;
  final String Name;
  final int CategoryType;
  final String GarderobeId;
  final List<Clothe> Clothes;

  Clothecategory({
    required this.Id,
    required this.CategoryType,
    required this.Clothes,
    required this.GarderobeId,
    required this.Name,
  });
}