import 'package:yconic/data/models/garderobe_model.dart';
import 'package:yconic/data/models/simple_user_model.dart';
import 'package:yconic/data/models/suggestion_model.dart';

class PublicUserProfileModel {
  final String id;
  final String username;
  final String? profilePhoto;
  final String? bio;
  final bool isPrivate;
  final int followerCount;
  final int followingCount;
  final GarderobeModel garderobe;
  final List<SimpleUserModel> followers;
  final List<SimpleUserModel> following;
  final List<SuggestionModel> suggestions;

  PublicUserProfileModel({
    required this.id,
    required this.username,
    required this.profilePhoto,
    required this.bio,
    required this.isPrivate,
    required this.followerCount,
    required this.followingCount,
    required this.garderobe,
    required this.followers,
    required this.following,
    required this.suggestions,
  });

  factory PublicUserProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicUserProfileModel(
      id: json['id'],
      username: json['username'],
      profilePhoto: json['profilePhoto'],
      bio: json['bio'],
      isPrivate: json['isPrivate'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      garderobe: GarderobeModel.fromJson(json['garderobe']),
      followers: (json['followers'] as List)
          .map((e) => SimpleUserModel.fromJson(e))
          .toList(),
      following: (json['following'] as List)
          .map((e) => SimpleUserModel.fromJson(e))
          .toList(),
      suggestions: (json['suggestions'] as List)
          .map((e) => SuggestionModel.fromJson(e))
          .toList(),
    );
  }
}
