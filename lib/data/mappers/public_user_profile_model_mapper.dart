import 'package:yconic/data/mappers/garderobe_model_mapper.dart';
import 'package:yconic/data/mappers/simple_user_model_mapper.dart';
import 'package:yconic/data/mappers/suggestion_model_mapper.dart';
import 'package:yconic/data/models/public_user_profile_model.dart';
import 'package:yconic/domain/entities/public_user_profile.dart';

extension PublicUserProfileMapper on PublicUserProfileModel {
  PublicUserProfile toEntity() {
    return PublicUserProfile(
      id: id,
      username: username,
      profilePhoto: profilePhoto,
      bio: bio,
      isPrivate: isPrivate,
      followerCount: followerCount,
      followingCount: followingCount,
      garderobe: garderobe.toEntity(),
      followers: followers.map((e) => e.toEntity()).toList(),
      following: following.map((e) => e.toEntity()).toList(),
      suggestions: suggestions.map((e) => e.toEntity()).toList(),
    );
  }
}
