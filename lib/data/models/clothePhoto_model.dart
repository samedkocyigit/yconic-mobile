class PhotoModel {
  final String id;
  final String url;
  final String clotheId;

  PhotoModel({
    required this.id,
    required this.url,
    required this.clotheId,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      url: json['url'] as String,
      clotheId: json['clotheId'] as String,
    );
  }
}
