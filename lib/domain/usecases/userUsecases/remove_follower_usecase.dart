import 'package:yconic/domain/repositories/user_repository.dart';

class RemoveFollowerUsecase {
  final UserRepository repository;

  RemoveFollowerUsecase(this.repository);

  Future<void> execute(String followerId, String followedId) async {
    await repository.removeFollower(followerId, followedId);
  }
}
