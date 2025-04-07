import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/clothe/create_clothe_dto.dart';
import 'package:yconic/domain/entities/clothe_category.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

class AddClothePopup extends ConsumerStatefulWidget {
  final ClotheCategory category;
  const AddClothePopup({super.key, required this.category});

  @override
  ConsumerState<AddClothePopup> createState() => _AddClothePopupState();
}

class _AddClothePopupState extends ConsumerState<AddClothePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final List<XFile> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImages() async {
    final images = await picker.pickMultiImage(imageQuality: 75);
    if (images.isNotEmpty) {
      setState(() => selectedImages.addAll(images));
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add New Clothe",
                  style: AppTextStyles.title.copyWith(fontSize: 24.sp)),
              SizedBox(height: 16.h),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Clothe Name",
                    labelStyle:
                        AppTextStyles.body.copyWith(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter a name"
                    : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: brandController,
                decoration: InputDecoration(
                    labelText: "Brand (optional)",
                    labelStyle:
                        AppTextStyles.body.copyWith(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)),
              ),
              SizedBox(height: 12.h),
              Text("Photos",
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 16.sp)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.w,
                children: [
                  ...selectedImages.map(
                    (img) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(img.path),
                            height: 80.h,
                            width: 80.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.remove(img);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 90, 89, 89),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.close,
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: pickImages,
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
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        selectedImages.isNotEmpty) {
                      try {
                        final dto = CreateClotheDto(
                          name: nameController.text.trim(),
                          brand: brandController.text.trim(),
                          categoryId: widget.category.Id,
                          photos: selectedImages,
                        );

                        await ref
                            .read(clotheNotifierProvider.notifier)
                            .createClothe(dto);

                        final userId = ref.read(userProvider)?.Id;
                        if (userId != null) {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .getUser(userId);
                          final updatedUser =
                              ref.read(authNotifierProvider).user;
                          ref.read(userProvider.notifier).state = updatedUser;
                        }

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to add clothe: $e")),
                        );
                      }
                    } else if (selectedImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please select at least one photo")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text("Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddClothePopup(BuildContext context, ClotheCategory category) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: AddClothePopup(category: category),
    ),
  );
}
