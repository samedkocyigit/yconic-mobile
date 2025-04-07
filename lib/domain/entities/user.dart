import 'package:yconic/domain/entities/garderobe.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/domain/entities/persona.dart';

class User {
  final String Id;
  final String Email;
  final String Username;
  final bool IsPrivate;
  final String? Name;
  final String? Surname;
  final String? ProfilePhoto;
  final int? FollowerCount;
  final int? FollowingCount;
  final String? Bio;
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
  final List<SimpleUser>? Followers;
  final List<SimpleUser>? Following;
  final List<SimpleUser>? RecievedFollowRequest;
  final List<SimpleUser>? SentFollowRequest;

  User(
      {required this.Id,
      required this.Email,
      required this.Username,
      required this.IsPrivate,
      this.Name,
      this.ProfilePhoto,
      this.FollowerCount,
      this.FollowingCount,
      this.Bio,
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
      this.Followers,
      this.Following,
      this.RecievedFollowRequest,
      this.SentFollowRequest});

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'email': Email,
      'username': Username,
      'name': Name,
      'surname': Surname,
      'profilePhoto': ProfilePhoto,
      'followerCount': FollowerCount,
      'followingCount': FollowingCount,
      'bio': Bio,
      'role': Role,
      'age': Age,
      'isPrivate': IsPrivate,
      'weight': Weight,
      'height': Height,
      'birthday': Birthday,
      'phoneNumber': PhoneNumber,
      'userPersonaId': UserPersonaId,
      'userPersona': UserPersona,
      'userGarderobeId': UserGarderobeId,
      'userGarderobe': UserGarderobe,
      'suggestions': Suggestions,
      'followers': Followers,
      'following': Following,
      'recievedFollowRequest': RecievedFollowRequest,
      'sentFollowRequest': SentFollowRequest,
    };
  }

  @override
  String toString() {
    return 'User(id: $Id, email: $Email, username: $Username, name: $Name, garderobe: $UserGarderobe, garderobeId: $UserGarderobeId),followers: $Followers,following: $Following, recievedFollowRequest: $RecievedFollowRequest,sentFollowRequest: $SentFollowRequest';
  }

  User copyWith({
    String? Id,
    String? Email,
    String? Username,
    String? Name,
    String? Surname,
    String? ProfilePhoto,
    int? FollowerCount,
    int? FollowingCount,
    String? Bio,
    bool? IsPrivate,
    int? Role,
    int? Age,
    double? Weight,
    double? Height,
    DateTime? Birthday,
    String? PhoneNumber,
    String? UserPersonaId,
    String? UserGarderobeId,
    Persona? UserPersona,
    Garderobe? UserGarderobe,
    List<Suggestion>? Suggestions,
    List<SimpleUser>? Followers,
    List<SimpleUser>? Following,
    List<SimpleUser>? RecievedFollowRequest,
    List<SimpleUser>? SentFollowRequest,
  }) {
    return User(
      Id: Id ?? this.Id,
      Email: Email ?? this.Email,
      Username: Username ?? this.Username,
      Name: Name ?? this.Name,
      Surname: Surname ?? this.Surname,
      ProfilePhoto: ProfilePhoto ?? this.ProfilePhoto,
      FollowerCount: FollowerCount ?? this.FollowerCount,
      FollowingCount: FollowingCount ?? this.FollowingCount,
      Bio: Bio ?? this.Bio,
      IsPrivate: IsPrivate ?? this.IsPrivate,
      Role: Role ?? this.Role,
      Age: Age ?? this.Age,
      Weight: Weight ?? this.Weight,
      Height: Height ?? this.Height,
      Birthday: Birthday ?? this.Birthday,
      PhoneNumber: PhoneNumber ?? this.PhoneNumber,
      UserPersonaId: UserPersonaId ?? this.UserPersonaId,
      UserGarderobeId: UserGarderobeId ?? this.UserGarderobeId,
      UserPersona: UserPersona ?? this.UserPersona,
      UserGarderobe: UserGarderobe ?? this.UserGarderobe,
      Suggestions: Suggestions ?? this.Suggestions,
      Followers: Followers ?? this.Followers,
      Following: Following ?? this.Following,
      RecievedFollowRequest:
          RecievedFollowRequest ?? this.RecievedFollowRequest,
      SentFollowRequest: SentFollowRequest ?? this.SentFollowRequest,
    );
  }
}

extension UserX on User {
  SimpleUser toSimpleUser() {
    return SimpleUser(
      id: Id,
      isPrivate: IsPrivate,
      username: Username,
      profilePhoto: ProfilePhoto,
    );
  }
}
