import 'package:yconic/data/models/persona_model.dart';
import 'package:yconic/domain/entities/persona.dart';

extension PersonaModelMapper on PersonaModel {
  Persona toEntity() {
    return Persona(Id: id, UserType: usertype, UserId: userId);
  }
}
