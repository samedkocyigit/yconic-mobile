import 'package:yconic/data/dtos/user/update_user_account_dto.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class UpdateUserAccountUsecase {
  UserRepository repository;

  UpdateUserAccountUsecase(this.repository);

  Future<User> execute(String id, UpdateUserAccountDto dto) async {
    return await repository.updateUserAccount(id, dto);
  }
}
