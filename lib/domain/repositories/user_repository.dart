import 'package:yconic/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String confirmPassword,
      String name, String surname, DateTime birthday, String phoneNumber);
  // Future logout();
  Future<User> getUserById(String id);
  // Future<User> updateUser(User user);
}
