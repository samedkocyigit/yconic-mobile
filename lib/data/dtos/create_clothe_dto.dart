import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateClotheDto {
  final String name;
  final String? brand;
  final String categoryId;
  final List<XFile> photos;

  CreateClotheDto({
    required this.name,
    this.brand,
    required this.categoryId,
    required this.photos,
  });

  Map<String, String> toFields() => {
        'name': name,
        if (brand != null && brand!.isNotEmpty) 'brand': brand!,
        'categoryId': categoryId,
      };

  List<File> get photoFiles => photos.map((xfile) => File(xfile.path)).toList();
}
