class ClothePhotoModel {
  final String id;
  final String url;
  final String clotheId;

  ClothePhotoModel({
    required this.id,
    required this.url,
    required this.clotheId,
  });

  factory ClothePhotoModel.fromJson(Map<String, dynamic> json) {
    return ClothePhotoModel(
      id: json['id'] as String,
      url: json['url'] as String,
      clotheId: json['clotheId'] as String,
    );
  }
}
