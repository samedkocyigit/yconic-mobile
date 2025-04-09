enum PersonaTypes {
  OldMoney,
  SmartCasual,
  BusinessCasual,
  Gothic,
  Boho,
  Preppy,
  Hipster,
  Minimalist,
  Streetwear,
  Rocker
}

extension PersonaTypesExtension on PersonaTypes {
  String get displayValue {
    switch (this) {
      case PersonaTypes.OldMoney:
        return "Old Money";
      case PersonaTypes.SmartCasual:
        return "Smart Casual";
      case PersonaTypes.BusinessCasual:
        return "Bussiness Casual";
      case PersonaTypes.Gothic:
        return "Gothic";
      case PersonaTypes.Boho:
        return "Boho";
      case PersonaTypes.Preppy:
        return "Preppy";
      case PersonaTypes.Hipster:
        return "Hipster";
      case PersonaTypes.Minimalist:
        return "Minimalist";
      case PersonaTypes.Streetwear:
        return "Streetwear";
      case PersonaTypes.Rocker:
        return "Rocker";
    }
  }
}
