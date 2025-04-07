class SimpleUserModel {
  final String id;
  final String username;
  final bool isPrivate;
  final String? profilePhoto;

  SimpleUserModel(
      {required this.id,
      required this.username,
      required this.isPrivate,
      this.profilePhoto});

  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      isPrivate: json['isPrivate'] as bool,
      profilePhoto: json['profilePhoto'] as String?,
    );
  }
}
