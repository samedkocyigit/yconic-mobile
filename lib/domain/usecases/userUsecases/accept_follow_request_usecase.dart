import 'package:yconic/domain/repositories/user_repository.dart';

class AcceptFollowRequestUsecase {
  final UserRepository repository;

  AcceptFollowRequestUsecase(this.repository);

  Future<void> execute(String targetUserId, String requesterId) async {
    await repository.acceptFollowRequest(targetUserId, requesterId);
  }
}
