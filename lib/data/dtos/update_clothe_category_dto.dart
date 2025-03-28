class UpdateClotheCategoryDto {
  final String id;
  final String? name;
  final int? categoryType;

  UpdateClotheCategoryDto({
    required this.id,
    this.name,
    this.categoryType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (categoryType != null) 'categoryType': categoryType,
      };
}
