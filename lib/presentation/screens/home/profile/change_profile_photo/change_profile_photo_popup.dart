import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/user/change_profile_photo_dto.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

Future<void> showChangeProfilePhotoPopup(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: const ChangeProfilePhotoPopup(),
    ),
  );
}

class ChangeProfilePhotoPopup extends ConsumerStatefulWidget {
  const ChangeProfilePhotoPopup({super.key});

  @override
  ConsumerState<ChangeProfilePhotoPopup> createState() =>
      _ChangeProfilePhotoPopupState();
}

class _ChangeProfilePhotoPopupState
    extends ConsumerState<ChangeProfilePhotoPopup> {
  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = picked);
    }
  }

  Future<void> uploadPhoto() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a photo")),
      );
      return;
    }

    final dto = ChangeProfilePhotoDto(photo: selectedImage!);
    try {
      await ref.read(authNotifierProvider.notifier).changeProfilePhoto(dto);
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile photo updated.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Change Profile Photo", style: AppTextStyles.title),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            children: [
              if (selectedImage != null)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(selectedImage!.path),
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: () => setState(() => selectedImage = null),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(4.w),
                          child: Icon(Icons.close,
                              color: Colors.white, size: 12.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              if (selectedImage == null)
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.grey.shade100,
                    ),
                    child: Icon(Icons.add_a_photo_outlined, size: 28.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: uploadPhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text("Upload", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
