import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class RegisterUsecase {
  final UserRepository repository;

  RegisterUsecase(this.repository);

  Future<User> execute(
      String email,
      String password,
      String confirmPassword,
      String name,
      String surname,
      DateTime birthday,
      String phoneNumber) async {
    return await repository.register(
        email, password, confirmPassword, name, surname, birthday, phoneNumber);
  }
}
