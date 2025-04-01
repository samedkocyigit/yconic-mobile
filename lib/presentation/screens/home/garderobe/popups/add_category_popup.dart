import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/clothe_category/create_clothe_category_dto.dart';
import 'package:yconic/data/enums/category_types.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCategoryPopup extends ConsumerStatefulWidget {
  const AddCategoryPopup({super.key});

  @override
  ConsumerState<AddCategoryPopup> createState() => _AddCategoryPopupState();
}

class _AddCategoryPopupState extends ConsumerState<AddCategoryPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  CategoryTypes? selectedType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 16.h),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Category", style: AppTextStyles.title),
              SizedBox(height: 16.h),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Category Name",
                    labelStyle:
                        AppTextStyles.body.copyWith(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Enter a category name"
                    : null,
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<CategoryTypes>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "Category Type",
                  labelStyle: AppTextStyles.body.copyWith(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
                style: AppTextStyles.body.copyWith(color: Colors.black),
                dropdownColor: Colors.white,
                items: CategoryTypes.values.map((type) {
                  return DropdownMenuItem<CategoryTypes>(
                    value: type,
                    child: Text(
                      type.displayValue,
                      style: AppTextStyles.body.copyWith(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Select a category type" : null,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = ref.read(userProvider);
                    if (user?.UserGarderobeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Garderobe not found")),
                      );
                      return;
                    }
                    final newCategory = CreateClotheCategoryDto(
                      name: nameController.text.trim(),
                      categoryType: selectedType!.index,
                      garderobeId: user!.UserGarderobeId!,
                    );
                    try {
                      await ref
                          .read(clotheCategoryNotifierProvider.notifier)
                          .createClotheCategory(newCategory);

                      final userId = ref.read(userProvider)?.Id;
                      if (userId != null) {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .getUser(userId);

                        final newUser = ref.read(authNotifierProvider).user;
                        print(
                            "Backend'den gelen category count: ${newUser?.UserGarderobe?.ClothesCategories.length}");

                        ref.read(userProvider.notifier).state = newUser;
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Text("Add Category",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddCategoryPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: const AddCategoryPopup(),
    ),
  );
}
