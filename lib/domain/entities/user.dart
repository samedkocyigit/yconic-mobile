class User{
  final String id;
  final String? name;
  final String email;
  final String? surname;
  final int? age;
  final double? height;
  final double? weight;
  final DateTime? birthday;
  final Status? isActive;
  final String? phoneNumber;
  final String? userPersonaId;
  final String? userGarderobeId;
  final Persona? userPersona;
  final Garderobe? userGarderobe;
  final List<Suggestions>? suggestions;

  User({
    required this.id,
    required this.email,
    this.surname,
    this.birthday,
    this.age,
    this.weight,
    this.height,
    this.isActive,
    this.userPersonaId,
    this.userGarderobeId
  });
}