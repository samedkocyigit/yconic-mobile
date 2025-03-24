import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/entities/Persona.dart';

class User {
  final String Id;
  final String Email;
  final String? Name;
  final String? Surname;
  final int? Role;
  final int? Age;
  final double? Weight;
  final double? Height;
  final DateTime? Birthday;
  final String? PhoneNumber;
  final String? UserPersonaId;
  final String? UserGarderobeId;
  final Persona? UserPersona;
  final Garderobe? UserGarderobe;
  final List<Suggestion>? Suggestions;

  User({
    required this.Id,
    required this.Email,
    this.Name,
    this.Surname,
    this.Role,
    this.Age,
    this.Weight,
    this.Height,
    this.Birthday,
    this.PhoneNumber,
    this.UserPersonaId,
    this.UserGarderobeId,
    this.UserGarderobe,
    this.UserPersona,
    this.Suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'email': Email,
      'name': Name,
      'surname': Surname,
      'role': Role,
      'age': Age,
      'weight': Weight,
      'height': Height,
      'birthday': Birthday,
      'phoneNumber': PhoneNumber,
      'userPersonaId': UserPersonaId,
      'userPersona': UserPersona,
      'userGarderobeId': UserGarderobeId,
      'userGarderobe': UserGarderobe,
      'suggestions': Suggestions,
    };
  }
}
