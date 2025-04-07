import 'package:yconic/data/models/garderobe_model.dart';
import 'package:yconic/data/models/simple_user_model.dart';
import 'package:yconic/data/models/suggestion_model.dart';
import 'package:yconic/data/models/persona_model.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final bool isPrivate;
  final String? name;
  final String? surname;
  final int? role;
  final int? age;
  final String? profilePhoto;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final int? followerCount;
  final int? followingCount;
  final String? bio;
  final DateTime? birthday;
  final String? userPersonaId;
  final String? userGarderobeId;
  final GarderobeModel? garderobe;
  final PersonaModel? persona;
  final List<SuggestionModel>? suggestions;
  final List<SimpleUserModel>? followers;
  final List<SimpleUserModel>? following;
  final List<SimpleUserModel>? recievedFollowRequest;
  final List<SimpleUserModel>? sentFollowRequest;

  UserModel(
      {required this.id,
      required this.email,
      required this.username,
      required this.isPrivate,
      this.name,
      this.surname,
      this.profilePhoto,
      this.followingCount,
      this.followerCount,
      this.bio,
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
      this.followers,
      this.following,
      this.recievedFollowRequest,
      this.sentFollowRequest});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      userPersonaId: json['userPersonaId'] as String?,
      followerCount: json['followerCount'] as int?,
      followingCount: json['followingCount'] as int?,
      role: json['role'] as int?,
      isPrivate: json['isPrivate'] as bool,
      age: json['age'] as int?,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
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
      followers: json['followers'] != null
          ? (json['followers'] as List)
              .map((e) => SimpleUserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      following: json['following'] != null
          ? (json['following'] as List)
              .map((e) => SimpleUserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      recievedFollowRequest: json['recievedFollowRequest'] != null
          ? (json['recievedFollowRequest'] as List)
              .map((e) => SimpleUserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      sentFollowRequest: json['sentFollowRequest'] != null
          ? (json['sentFollowRequest'] as List)
              .map((e) => SimpleUserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
