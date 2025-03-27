import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/create_clothe_category_dto.dart';
import 'package:yconic/data/enums/category_types.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

class AddCategoryPopup extends ConsumerStatefulWidget {
  const AddCategoryPopup({Key? key}) : super(key: key);

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
          left: 16,
          right: 16,
          top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Category", style: AppTextStyles.title),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Enter a category name"
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoryTypes>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "Category Type",
                  labelStyle:
                      AppTextStyles.bodyBold.copyWith(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
                            "Backend'den gelen category count: ${newUser?.UserGarderobe?.ClothesCategories?.length}");

                        ref.read(userProvider.notifier).state = newUser;
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text("Add Category",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
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
