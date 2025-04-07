import 'package:yconic/domain/repositories/user_repository.dart';

class FollowUserUsecase {
  final UserRepository repository;

  FollowUserUsecase(this.repository);

  Future<void> execute(String followerId, String followedId) async {
    await repository.followUser(followerId, followedId);
  }
}
