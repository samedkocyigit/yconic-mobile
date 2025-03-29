class PatchClotheRequestDto {
  final String? name;
  final String? brand;
  final String? description;

  PatchClotheRequestDto({this.name, this.brand, this.description});

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (description != null) 'description': description,
    };
  }
}
