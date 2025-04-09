import 'package:yconic/data/dtos/user/update_user_personal_dto.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class UpdateUserPersonalUsecase {
  UserRepository repository;

  UpdateUserPersonalUsecase(this.repository);

  Future<User> execute(String id, UpdateUserPersonalDto dto) async {
    return await repository.updateUserPersonal(id, dto);
  }
}
