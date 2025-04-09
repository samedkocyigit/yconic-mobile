import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ChangeProfilePhotoDto {
  final XFile photo;

  ChangeProfilePhotoDto({required this.photo});

  File get photoFile => File(photo.path);
}
