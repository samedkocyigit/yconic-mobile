import 'package:yconic/domain/entities/public_user_profile.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class GetPublicUserProfileUsecase {
  final UserRepository repository;
  GetPublicUserProfileUsecase(this.repository);

  Future<PublicUserProfile> execute(String userId) {
    return repository.getPublicUserProfile(userId);
  }
}
