import 'package:yconic/domain/entities/simple_user.dart';

class FollowState {
  final List<SimpleUser> followers;
  final List<SimpleUser> following;
  final List<SimpleUser> requests;

  FollowState({
    required this.followers,
    required this.following,
    required this.requests,
  });

  FollowState copyWith({
    List<SimpleUser>? followers,
    List<SimpleUser>? following,
    List<SimpleUser>? requests,
  }) {
    return FollowState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      requests: requests ?? this.requests,
    );
  }
}
