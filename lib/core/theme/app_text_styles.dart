import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle headline = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle title = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle titleLarge = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextTheme get textTheme => TextTheme(
        displayLarge: headline,
        titleLarge: titleLarge,
        bodyLarge: body,
        bodyMedium: body,
        labelLarge: button,
      );
}
