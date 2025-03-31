import 'package:yconic/domain/repositories/user_repository.dart';

class RegisterUsecase {
  final UserRepository repository;

  RegisterUsecase(this.repository);

  Future<void> execute(
    String email,
    String username,
    String password,
  ) async {
    await repository.register(email, username, password);
  }
}
