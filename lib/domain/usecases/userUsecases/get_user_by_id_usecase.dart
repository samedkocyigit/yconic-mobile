import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class GetUserByIdUsecase {
  final UserRepository repository;

  GetUserByIdUsecase(this.repository);

  Future<User> execute(String id) async {
    return await repository.getUserById(id);
  }
}
