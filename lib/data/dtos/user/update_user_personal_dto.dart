class UpdateUserPersonalDto {
  final String? username;
  final String? name;
  final String? surname;
  final String? bio;

  UpdateUserPersonalDto({this.username, this.name, this.surname, this.bio});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'surname': surname,
      'bio': bio,
    };
  }
}
