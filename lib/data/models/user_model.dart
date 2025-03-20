import 'package:yconic_mobile/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final int? role;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? userPersonaId;
  final String? userGarderobeId;
  final GarderobeModel? garderobe;
  final PersonaModel? persona;
  final List<SuggestionModel>? suggestions;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.role,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.userPersonaId,
    this.userGarderobeId,
    this.garderobe,
    this.persona,
    this.suggestions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      role: json['role'] as int?,
      age: json['age'] as int?,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      phoneNumber: json['phoneNumber'] as String?,
      userPersonaId: json['userPersonaId'] as String?,
      userGarderobeId: json['userGarderobeId'] as String?,
      garderobe: json['garderobe'] != null
          ? GarderobeModel.fromJson(json['garderobe'] as Map<String, dynamic>)
          : null,
      persona: json['persona'] != null
          ? PersonaModel.fromJson(json['persona'] as Map<String, dynamic>)
          : null,
      suggestions: json['suggestions'] != null
          ? (json['suggestions'] as List)
              .map((e) =>
                  SuggestionModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
