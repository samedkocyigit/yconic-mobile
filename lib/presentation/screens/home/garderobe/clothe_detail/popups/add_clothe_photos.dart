import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/clothe_photos/create_clothe_photos.dto.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_provider.dart';

Future<bool?> showAddClothePhotoPopup(BuildContext context, String clotheId) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: AddClothePhotoPopup(clotheId: clotheId),
    ),
  );
}

class AddClothePhotoPopup extends ConsumerStatefulWidget {
  final String clotheId;
  const AddClothePhotoPopup({super.key, required this.clotheId});

  @override
  ConsumerState<AddClothePhotoPopup> createState() =>
      _AddClothePhotoPopupState();
}

class _AddClothePhotoPopupState extends ConsumerState<AddClothePhotoPopup> {
  final List<XFile> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImages() async {
    final images = await picker.pickMultiImage(imageQuality: 75);
    if (images.isNotEmpty) {
      setState(() => selectedImages.addAll(images));
    }
  }

  Future<void> uploadPhotos() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one photo")),
      );
      return;
    }

    final dto = CreateClothePhotoDto(
      clotheId: widget.clotheId,
      photos: selectedImages,
    );

    try {
      await ref
          .read(clothePhotoNotifierProvider.notifier)
          .createClothePhoto(dto);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photos added successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload photo: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Photos", style: AppTextStyles.title),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selectedImages.map((img) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(img.path),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: uploadPhotos,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child:
                  const Text("Upload", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
