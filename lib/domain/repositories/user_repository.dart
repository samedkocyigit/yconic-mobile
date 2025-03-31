import 'package:yconic/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String username, String password);
  Future<User> getUserById(String id);
  // Future logout();
  // Future<User> updateUser(User user);
}
