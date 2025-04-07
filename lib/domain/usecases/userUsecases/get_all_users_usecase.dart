import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class GetAllUsersUsecase {
  final UserRepository repository;

  GetAllUsersUsecase(this.repository);

  Future<List<SimpleUser>> execute() async {
    return await repository.getAllUsers();
  }
}
