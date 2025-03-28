import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/enums/category_types.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';
import 'package:yconic/data/dtos/update_clothe_category_dto.dart';

class EditCategoryPopup extends ConsumerStatefulWidget {
  final ClotheCategory category;

  const EditCategoryPopup({super.key, required this.category});

  @override
  ConsumerState<EditCategoryPopup> createState() => _EditCategoryPopupState();
}

class _EditCategoryPopupState extends ConsumerState<EditCategoryPopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  CategoryTypes? selectedType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.Name);
    selectedType = CategoryTypes.values[widget.category.CategoryType];
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
              Text("Edit Category", style: AppTextStyles.title),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Category Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CategoryTypes>(
                    value: selectedType,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    items: CategoryTypes.values.map((type) {
                      return DropdownMenuItem<CategoryTypes>(
                        value: type,
                        child: Row(
                          children: [
                            Icon(Icons.label_outline,
                                size: 18, color: Colors.grey.shade700),
                            const SizedBox(width: 8),
                            Text(
                              type.displayValue,
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final nameChanged =
                          nameController.text.trim() != widget.category.Name;
                      final typeChanged =
                          selectedType!.index != widget.category.CategoryType;

                      if (!nameChanged && !typeChanged) {
                        Navigator.pop(context);
                        return;
                      }

                      final updateDto = UpdateClotheCategoryDto(
                        id: widget.category.Id,
                        name: nameChanged ? nameController.text.trim() : null,
                        categoryType: typeChanged ? selectedType!.index : null,
                      );

                      try {
                        await ref
                            .read(clotheCategoryNotifierProvider.notifier)
                            .updateClotheCategory(updateDto);

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
                          SnackBar(content: Text(e.toString())),
                        );
                      }
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

void showEditCategoryPopup(BuildContext context, ClotheCategory category) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: EditCategoryPopup(category: category),
    ),
  );
}
