import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_colors.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/clothe_category/clothe_category_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';
import 'package:yconic/presentation/screens/home/garderobe/clothe_detail/clothe_detail_screen.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/add_category_popup.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/add_clothe_popup.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/category_button_sheet.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/clothe_buttom_sheet.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/edit_category_popup.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/edit_clothe_popup.dart';
import 'package:yconic/presentation/screens/home/garderobe/widgets/category_tab_item.dart';
import 'package:yconic/presentation/screens/home/garderobe/widgets/clothe_card.dart';

class GarderobeScreen extends ConsumerStatefulWidget {
  const GarderobeScreen({super.key});

  @override
  ConsumerState<GarderobeScreen> createState() => _GarderobeScreenState();
}

class _GarderobeScreenState extends ConsumerState<GarderobeScreen> {
  int selectedCategoryIndex = 0;

  void _showCategoryOptionsDialog(
      BuildContext context, ClotheCategory category) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => CategoryOptionsBottomSheet(
        category: category,
        onEdit: () => showEditCategoryPopup(context, category),
        onDelete: () async {
          try {
            await ref
                .read(clotheCategoryNotifierProvider.notifier)
                .deleteClotheCategory(category.Id);
            final userId = ref.read(userProvider)?.Id;
            if (userId != null) {
              await ref.read(authNotifierProvider.notifier).getUser(userId);
              final updatedUser = ref.read(authNotifierProvider).user;
              ref.read(userProvider.notifier).state = updatedUser;
            }
            if (selectedCategoryIndex >=
                ref.read(clotheCategoriesProvider).length) {
              setState(() => selectedCategoryIndex = 0);
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  void _showClotheOptionsPopup(Clothe clothe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => ClotheOptionsBottomSheet(
        clothe: clothe,
        onEdit: () async {
          final result = await showEditClothePopup(context, ref, clothe);
          if (result == true) {
            final updated = await ref
                .read(clotheNotifierProvider.notifier)
                .getClothe(clothe.Id);
            final garderobe = ref.read(userProvider)?.UserGarderobe;
            final category = garderobe?.ClothesCategories
                .firstWhere((c) => c.Id == clothe.CategoryId);
            if (category != null) {
              final index =
                  category.Clothes.indexWhere((c) => c.Id == updated.Id);
              if (index != -1) {
                category.Clothes[index] = updated;
                ref.read(userProvider.notifier).state =
                    ref.read(authNotifierProvider).user;
              }
            }
          }
        },
        onDelete: () async {
          try {
            await ref
                .read(clotheNotifierProvider.notifier)
                .deleteClothe(clothe.Id);
            final userId = ref.read(userProvider)?.Id;
            if (userId != null) {
              await ref.read(authNotifierProvider.notifier).getUser(userId);
              final updatedUser = ref.read(authNotifierProvider).user;
              ref.read(userProvider.notifier).state = updatedUser;
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(clotheCategoriesProvider);

    if (categories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No categories found in your garderobe.",
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => showAddCategoryPopup(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Category"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final selectedCategory = categories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        width: 64.w,
        height: 64.h,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.black,
          onPressed: () => showAddClothePopup(context, selectedCategory),
          child: Icon(Icons.add, size: 28.sp, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Garderobe", style: AppTextStyles.headline),
              SizedBox(height: 12.h),
              SizedBox(
                height: 42.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      return OutlinedButton(
                        onPressed: () => showAddCategoryPopup(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(color: Colors.grey.shade400),
                          backgroundColor: Colors.white,
                        ),
                        child: Text("+ Category", style: AppTextStyles.body),
                      );
                    }

                    final category = categories[index];
                    return CategoryTabItem(
                      category: category,
                      isSelected: selectedCategoryIndex == index,
                      onTap: () =>
                          setState(() => selectedCategoryIndex = index),
                      onLongPress: () =>
                          _showCategoryOptionsDialog(context, category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: selectedCategory.Clothes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final clothe = selectedCategory.Clothes[index];
                    return ClotheCard(
                      clothe: clothe,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClotheDetailScreen(clothe: clothe),
                          ),
                        );
                        if (result is Map && result['deleted'] == true) {
                          final userId = ref.read(userProvider)?.Id;
                          if (userId != null) {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .getUser(userId);
                            final updatedUser =
                                ref.read(authNotifierProvider).user;
                            ref.read(userProvider.notifier).state = updatedUser;
                          }

                          final categoryId = result['categoryId'];
                          final categories = ref.read(clotheCategoriesProvider);
                          final categoryIndex =
                              categories.indexWhere((c) => c.Id == categoryId);
                          if (categoryIndex != -1) {
                            setState(
                                () => selectedCategoryIndex = categoryIndex);
                          }
                        }
                      },
                      onLongPress: () => _showClotheOptionsPopup(clothe),
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
