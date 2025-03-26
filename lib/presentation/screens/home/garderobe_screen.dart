import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/clothe_category_provider.dart';
import 'package:yconic/core/theme/app_colors.dart';
import 'package:yconic/core/theme/app_text_styles.dart';

class GarderobeScreen extends ConsumerStatefulWidget {
  const GarderobeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GarderobeScreen> createState() => _GarderobeScreenState();
}

class _GarderobeScreenState extends ConsumerState<GarderobeScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(clothesCategoryProvider);

    if (categories.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
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
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final isSelected = (index == selectedCategoryIndex);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            category.Name,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          selectedColor: AppColors.accent,
                          backgroundColor: Colors.white54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  selectedCategory.Name,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: selectedCategory.Clothes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, clothIndex) {
                      final clothe = selectedCategory.Clothes[clothIndex];
                      final imageUrl =
                          'http://10.0.2.2:5000${clothe.MainPhoto}';

                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to clothe detail page
                        },
                        child: Card(
                          color: AppColors.inputFill,
                          elevation: 6,
                          shadowColor: AppColors.accent.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  clothe.Name,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyBold.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
