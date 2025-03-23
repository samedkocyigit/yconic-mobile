import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/entities/userPersona.dart';

class User{
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
  final Userpersona? UserPersona;
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
}