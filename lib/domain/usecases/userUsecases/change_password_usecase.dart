import 'package:yconic/data/dtos/user/change_password_dto.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class ChangePasswordUsecase {
  final UserRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<void> execute(String id, ChangePasswordDto dto) async {
    await repository.changePassword(id, dto);
  }
}
