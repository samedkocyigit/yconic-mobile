import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/domain/entities/clotheCategory.dart';

typedef CategoryActionCallback = void Function();

class CategoryOptionsBottomSheet extends StatelessWidget {
  final ClotheCategory category;
  final CategoryActionCallback onEdit;
  final CategoryActionCallback onDelete;

  const CategoryOptionsBottomSheet({
    super.key,
    required this.category,
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
            title: Text(
              'Edit',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, size: 24.sp, color: Colors.redAccent),
            title: Text(
              'Delete',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text("Delete Category"),
                  content: Text(
                      "Are you sure you want to delete '\${category.Name}'?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.white)),
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
