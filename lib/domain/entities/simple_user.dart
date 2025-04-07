class SimpleUser {
  final String id;
  final String username;
  final bool isPrivate;
  final String? profilePhoto;

  SimpleUser(
      {required this.id,
      required this.username,
      required this.isPrivate,
      this.profilePhoto});

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['id'],
      isPrivate: json['isPrivate'],
      username: json['username'],
      profilePhoto: json['profilePhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isPrivate': isPrivate,
      'profilePhoto': profilePhoto,
    };
  }
}
