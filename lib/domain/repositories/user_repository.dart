import 'package:yconic/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String password, String confirmPassword,
      String name, String surname, DateTime birthday, String phoneNumber);
  Future<User> getUserById(String id);
  // Future logout();
  // Future<User> updateUser(User user);
}
