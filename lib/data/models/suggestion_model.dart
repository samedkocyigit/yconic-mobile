class SuggestionModel {
  final String id;
  final String userId;
  final String? description;
  final String? image;
  final String createdAt;
  final List<ClotheModel> suggestedLook;

  SuggestionModel({
    required this.id,
    required this.userId,
    this.description,
    this.image,
    required this.createdAt,
    required this.suggestedLook,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String, // veya DateTime parse
      suggestedLook: (json['suggestedLook'] as List)
          .map((e) => ClotheModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
