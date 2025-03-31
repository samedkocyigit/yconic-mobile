import 'package:yconic/data/models/garderobe_model.dart';
import 'package:yconic/data/models/suggestion_model.dart';
import 'package:yconic/data/models/persona_model.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String? name;
  final String? surname;
  final int? role;
  final int? age;
  final double? weight;
  final double? height;
  final DateTime? birthday;
  final String? phoneNumber;
  final String? userPersonaId;
  final String? userGarderobeId;
  final PersonaModel? persona;
  final GarderobeModel? garderobe;
  final List<SuggestionModel>? suggestions;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.name,
    this.surname,
    this.role,
    this.age,
    this.weight,
    this.height,
    this.birthday,
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
      username: json['username'] as String,
      name: json['name'] != null ? (json['name'] as String) : null,
      surname: json['surname'] != null ? (json['surname'] as String) : null,
      role: json['role'] as int?,
      age: json['age'] as int?,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      phoneNumber:
          json['phoneNumber'] != null ? (json['phoneNumber'] as String) : null,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      userPersonaId: json['userPersonaId'] != null
          ? (json['userPersonaId'] as String)
          : null,
      userGarderobeId: json['userGarderobeId'] as String?,
      garderobe: json['garderobe'] != null
          ? GarderobeModel.fromJson(json['garderobe'] as Map<String, dynamic>)
          : null,
      persona: json['persona'] != null
          ? PersonaModel.fromJson(json['persona'] as Map<String, dynamic>)
          : null,
      suggestions: json['suggestions'] != null
          ? (json['suggestions'] as List)
              .map((e) => SuggestionModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
