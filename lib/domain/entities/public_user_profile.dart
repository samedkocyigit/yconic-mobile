import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/entities/suggestion.dart';

class PublicUserProfile {
  final String id;
  final String username;
  final String? name;
  final String? profilePhoto;
  final bool isPrivate;
  final int followerCount;
  final int followingCount;
  final String? bio;
  final List<SimpleUser> followers;
  final List<SimpleUser> following;
  final Garderobe? garderobe;
  final List<Suggestion> suggestions;

  PublicUserProfile({
    required this.id,
    required this.username,
    this.name,
    this.profilePhoto,
    required this.isPrivate,
    required this.followerCount,
    required this.followingCount,
    this.bio,
    required this.followers,
    required this.following,
    this.garderobe,
    required this.suggestions,
  });

  PublicUserProfile copyWith({
    String? id,
    String? username,
    String? name,
    String? profilePhoto,
    bool? isPrivate,
    int? followerCount,
    int? followingCount,
    String? bio,
    List<SimpleUser>? followers,
    List<SimpleUser>? following,
    Garderobe? garderobe,
    List<Suggestion>? suggestions,
  }) {
    return PublicUserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isPrivate: isPrivate ?? this.isPrivate,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      garderobe: garderobe ?? this.garderobe,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
