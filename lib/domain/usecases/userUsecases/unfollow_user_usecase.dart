import 'package:yconic/domain/repositories/user_repository.dart';

class UnfollowUserUsecase {
  final UserRepository repository;

  UnfollowUserUsecase(this.repository);

  Future<void> execute(String followerId, String followedId) async {
    await repository.unfollowUser(followerId, followedId);
  }
}
