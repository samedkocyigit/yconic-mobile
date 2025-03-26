import 'package:yconic/domain/repositories/user_repository.dart';

class RegisterUsecase {
  final UserRepository repository;

  RegisterUsecase(this.repository);

  Future<void> execute(
      String email,
      String password,
      String confirmPassword,
      String name,
      String surname,
      DateTime birthday,
      String phoneNumber) async {
    await repository.register(
        email, password, confirmPassword, name, surname, birthday, phoneNumber);
  }
}
