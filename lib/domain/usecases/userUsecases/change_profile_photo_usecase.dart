import 'package:yconic/data/dtos/user/change_profile_photo_dto.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/domain/repositories/user_repository.dart';

class ChangeProfilePhotoUsecase {
  final UserRepository repository;

  ChangeProfilePhotoUsecase(this.repository);

  Future<User> execute(String id, ChangeProfilePhotoDto dto) async {
    return await repository.changeProfilePhoto(id, dto);
  }
}
