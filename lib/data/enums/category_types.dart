enum CategoryTypes {
  Top,
  Bottom,
  Shoes,
  Outwear,
  Accessories,
}

extension CategoryTypesExtension on CategoryTypes {
  String get displayValue {
    switch (this) {
      case CategoryTypes.Top:
        return "Top";
      case CategoryTypes.Bottom:
        return "Bottom";
      case CategoryTypes.Shoes:
        return "Shoes";
      case CategoryTypes.Outwear:
        return "Outwear";
      case CategoryTypes.Accessories:
        return "Accessories";
    }
  }
}
