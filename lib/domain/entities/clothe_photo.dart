class ClothePhoto {
  final String Id;
  final String Url;
  final String ClotheId;

  ClothePhoto({required this.Id, required this.Url, required this.ClotheId});

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'url': Url,
      'clotheId': ClotheId,
    };
  }
}
