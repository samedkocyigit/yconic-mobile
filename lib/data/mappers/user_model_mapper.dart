import 'package:yconic/data/mappers/garderobe_model_mapper.dart';
import 'package:yconic/data/mappers/persona_model_mapper.dart';
import 'package:yconic/data/mappers/simple_user_model_mapper.dart';
import 'package:yconic/data/mappers/suggestion_model_mapper.dart';
import 'package:yconic/data/models/user_model.dart';
import 'package:yconic/domain/entities/user.dart';

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      Id: id,
      Email: email,
      Username: username,
      Name: name,
      Surname: surname,
      FollowerCount: followerCount,
      FollowingCount: followingCount,
      Bio: bio,
      IsPrivate: isPrivate,
      Role: role,
      Age: age,
      ProfilePhoto: profilePhoto,
      Weight: weight,
      Height: height,
      Birthday: birthday,
      PhoneNumber: phoneNumber,
      UserPersonaId: userPersonaId,
      UserGarderobeId: userGarderobeId,
      UserPersona: persona?.toEntity(),
      UserGarderobe: garderobe?.toEntity(),
      Suggestions: suggestions?.map((s) => s.toEntity()).toList(),
      Followers: followers?.map((s) => s.toEntity()).toList(),
      Following: following?.map((s) => s.toEntity()).toList(),
      RecievedFollowRequest:
          recievedFollowRequest?.map((s) => s.toEntity()).toList(),
      SentFollowRequest: sentFollowRequest?.map((s) => s.toEntity()).toList(),
    );
  }
}
