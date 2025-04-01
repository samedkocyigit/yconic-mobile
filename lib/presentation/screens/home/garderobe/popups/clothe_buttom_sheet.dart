import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnActionCallback = void Function();

class ClotheOptionsBottomSheet extends StatelessWidget {
  final OnActionCallback onEdit;
  final OnActionCallback onDelete;

  const ClotheOptionsBottomSheet({
    super.key,
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
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
