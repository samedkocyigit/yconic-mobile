import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class ChangePrivacyUsecase {
  UserRepository repository;

  ChangePrivacyUsecase(this.repository);

  Future<User> execute(String id) async {
    return await repository.changePrivacy(id);
  }
}
