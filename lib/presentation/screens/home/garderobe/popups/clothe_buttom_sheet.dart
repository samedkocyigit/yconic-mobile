import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';

typedef OnActionCallback = void Function();

class ClotheOptionsBottomSheet extends StatelessWidget {
  final Clothe clothe;
  final OnActionCallback onEdit;
  final OnActionCallback onDelete;

  const ClotheOptionsBottomSheet({
    super.key,
    required this.clothe,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit, size: 24.sp),
            title: Text('Edit',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, size: 24.sp, color: Colors.redAccent),
            title: Text('Delete',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent)),
            onTap: () async {
              Navigator.pop(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                  backgroundColor: Colors.white,
                  title: Text(
                    "Delete Clothing",
                    style: AppTextStyles.title.copyWith(fontSize: 20.sp),
                  ),
                  content: Text(
                    "Are you sure you want to delete '${clothe.Name}'",
                    style: AppTextStyles.body.copyWith(fontSize: 14.sp),
                  ),
                  actionsPadding: EdgeInsets.only(bottom: 8.h, right: 8.w),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.grey.shade700),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}
