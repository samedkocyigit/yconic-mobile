import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';
import 'package:yconic/core/theme/app_colors.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/presentation/screens/home/garderobe/add_category_popup.dart';
import 'package:yconic/presentation/screens/home/garderobe/add_clothe_popup.dart';

class GarderobeScreen extends ConsumerStatefulWidget {
  const GarderobeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GarderobeScreen> createState() => _GarderobeScreenState();
}

class _GarderobeScreenState extends ConsumerState<GarderobeScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(clotheCategoriesProvider);

    if (categories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            "No categories found in your garderobe.",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final selectedCategory = categories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddClothePopup(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Garderobe",
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 12),
              // Kategori seçim alanı: Kategori butonları
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      return OutlinedButton(
                        onPressed: () {
                          showAddCategoryPopup(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "+ Category",
                          style: AppTextStyles.body,
                        ),
                      );
                    }

                    final category = categories[index];
                    final isSelected = selectedCategoryIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category.Name,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: selectedCategory.Clothes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, clothIndex) {
                    final clothe = selectedCategory.Clothes[clothIndex];
                    final imageUrl = 'http://10.0.2.2:5000${clothe.MainPhoto}';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // TODO: Navigate to clothe detail page
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    Uri.encodeFull(imageUrl),
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, _, __) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  clothe.Name,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
