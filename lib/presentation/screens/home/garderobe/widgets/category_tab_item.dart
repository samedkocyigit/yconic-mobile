import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';

typedef OnCategoryTap = void Function();

class CategoryTabItem extends StatelessWidget {
  final ClotheCategory category;
  final bool isSelected;
  final OnCategoryTap onTap;
  final OnCategoryTap onLongPress;

  const CategoryTabItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade400,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100.w),
            child: Text(
              category.Name,
              style: AppTextStyles.body.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
