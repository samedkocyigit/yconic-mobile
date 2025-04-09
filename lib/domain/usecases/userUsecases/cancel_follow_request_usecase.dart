import 'package:yconic/domain/repositories/user_repository.dart';

class CancelFollowRequestUsecase {
  final UserRepository repository;

  CancelFollowRequestUsecase(this.repository);

  Future<void> execute(String requesterId, String targetUserId) async {
    await repository.cancelFollowRequest(requesterId, targetUserId);
  }
}
