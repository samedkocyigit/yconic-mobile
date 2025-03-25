import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UserRepository repository;

  LoginUsecase(this.repository);

  Future<User> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}
