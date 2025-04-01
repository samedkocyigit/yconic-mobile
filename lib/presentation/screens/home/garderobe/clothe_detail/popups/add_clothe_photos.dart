import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Photos", style: AppTextStyles.title),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                ...selectedImages.map((img) => ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(img.path),
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                      ),
                    )),
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Center(
              child: ElevatedButton(
                onPressed: uploadPhotos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
                child: Text("Upload",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
