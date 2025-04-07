import 'package:yconic/data/models/simple_user_model.dart';
import 'package:yconic/domain/entities/simple_user.dart';

extension SimpleUserModelMapper on SimpleUserModel {
  SimpleUser toEntity() {
    return SimpleUser(
        id: id,
        username: username,
        isPrivate: isPrivate,
        profilePhoto: profilePhoto);
  }
}
