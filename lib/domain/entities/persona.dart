class Persona {
  final String Id;
  final int UserType;
  final String UserId;

  Persona({required this.Id, required this.UserType, required this.UserId});

  Map<String, dynamic> toJson() {
    return {'id': Id, 'userTypre': UserType, 'userId': UserId};
  }
}
