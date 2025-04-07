import 'package:yconic/domain/repositories/user_repository.dart';

class SendFollowRequestUsecase {
  final UserRepository repository;

  SendFollowRequestUsecase(this.repository);

  Future<void> execute(String requesterId, String targetUserId) async {
    await repository.sendFollowRequest(requesterId, targetUserId);
  }
}
