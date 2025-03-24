import 'package:yconic/data/mappers/garderobe_model_mapper.dart';
import 'package:yconic/data/mappers/persona_model_mapper.dart';
import 'package:yconic/data/mappers/suggestion_model_mapper.dart';
import 'package:yconic/data/models/user_model.dart';
import 'package:yconic/domain/entities/user.dart';

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      Id: id,
      Email: email,
      Name: name,
      Surname: surname,
      Role: role,
      Age: age,
      Weight: weight,
      Height: height,
      Birthday: birthday,
      PhoneNumber: phoneNumber,
      UserPersonaId: userPersonaId,
      UserGarderobeId: userGarderobeId,
      UserPersona: persona?.toEntity(),
      UserGarderobe: garderobe?.toEntity(),
      Suggestions: suggestions?.map((s) => s.toEntity()).toList(),
    );
  }
}
