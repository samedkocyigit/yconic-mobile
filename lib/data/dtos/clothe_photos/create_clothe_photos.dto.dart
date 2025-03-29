import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateClothePhotoDto {
  final String clotheId;
  final List<XFile> photos;

  CreateClothePhotoDto({
    required this.clotheId,
    required this.photos,
  });

  Map<String, String> toFields() => {
        'clotheId': clotheId,
      };

  List<File> get photoFiles => photos.map((xfile) => File(xfile.path)).toList();
}
