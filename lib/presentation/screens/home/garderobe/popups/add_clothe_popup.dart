import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/clothe/create_clothe_dto.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
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
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add New Clothe", style: AppTextStyles.title),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Clothe Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter a name"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: brandController,
                decoration: InputDecoration(
                  labelText: "Brand (optional)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Text("Photos", style: AppTextStyles.bodyBold),
              const SizedBox(height: 8),
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
              const SizedBox(height: 20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
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
