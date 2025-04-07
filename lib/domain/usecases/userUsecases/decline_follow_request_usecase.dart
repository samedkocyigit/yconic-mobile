import 'package:yconic/domain/repositories/user_repository.dart';

class DeclineFollowRequestUsecase {
  final UserRepository repository;

  DeclineFollowRequestUsecase(this.repository);

  Future<void> execute(String targetUserId, String requesterId) async {
    await repository.declineFollowRequest(targetUserId, requesterId);
  }
}
