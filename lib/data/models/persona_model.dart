class PersonaModel {
  final String id;
  final int usertype;
  final String userId;

  PersonaModel({
    required this.id,
    required this.usertype,
    required this.userId,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: json['id'] as String,
      usertype: json['usertype'] as int,
      userId: json['userId'] as String,
    );
  }
}
