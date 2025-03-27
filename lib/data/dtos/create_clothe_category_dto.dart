class CreateClotheCategoryDto {
  final String name;
  final int categoryType;
  final String garderobeId;

  CreateClotheCategoryDto({
    required this.name,
    required this.categoryType,
    required this.garderobeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryType': categoryType,
      'garderobeId': garderobeId,
    };
  }
}
