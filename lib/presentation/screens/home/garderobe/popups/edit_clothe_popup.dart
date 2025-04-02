import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/clothe/patch_clothe_request_dto.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

Future<bool?> showEditClothePopup(
    BuildContext context, WidgetRef ref, Clothe clothe) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: EditClothePopup(clothe: clothe),
    ),
  );
}

class EditClothePopup extends ConsumerStatefulWidget {
  final Clothe clothe;
  const EditClothePopup({super.key, required this.clothe});

  @override
  ConsumerState<EditClothePopup> createState() => _EditClothePopupState();
}

class _EditClothePopupState extends ConsumerState<EditClothePopup> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.clothe.Name);
    brandController = TextEditingController(text: widget.clothe.Brand);
    descController =
        TextEditingController(text: widget.clothe.Description ?? "");
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final brand = brandController.text.trim();
    final desc = descController.text.trim();

    final dto = PatchClotheRequestDto(
      name: name.isNotEmpty && name != widget.clothe.Name ? name : null,
      brand: brand != widget.clothe.Brand ? brand : null,
      description: desc != (widget.clothe.Description ?? '') ? desc : null,
    );

    if (dto.name == null && dto.brand == null && dto.description == null) {
      Navigator.pop(context);
      return;
    }

    try {
      await ref
          .read(clotheNotifierProvider.notifier)
          .updateClothe(widget.clothe.Id, dto);

      final userId = ref.read(userProvider)?.Id;
      if (userId != null) {
        await ref.read(authNotifierProvider.notifier).getUser(userId);
        final updatedUser = ref.read(authNotifierProvider).user;
        ref.read(userProvider.notifier).state = updatedUser;
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Clothing updated successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update clothing: $e")),
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
            Text("Edit Clothing",
                style: AppTextStyles.title.copyWith(fontSize: 24.sp)),
            SizedBox(height: 16.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Clothe Name",
                labelStyle: AppTextStyles.body.copyWith(color: Colors.black),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: "Brand",
                labelStyle: AppTextStyles.body.copyWith(color: Colors.black),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: AppTextStyles.body.copyWith(color: Colors.black),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
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
    );
  }
}
