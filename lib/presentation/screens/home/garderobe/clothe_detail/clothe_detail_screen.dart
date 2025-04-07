import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';
import 'package:yconic/presentation/screens/home/garderobe/clothe_detail/popups/add_clothe_photos.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/clothe_buttom_sheet.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/edit_clothe_popup.dart';

class ClotheDetailScreen extends ConsumerStatefulWidget {
  final Clothe clothe;

  const ClotheDetailScreen({super.key, required this.clothe});

  @override
  ConsumerState<ClotheDetailScreen> createState() => _ClotheDetailScreenState();
}

class _ClotheDetailScreenState extends ConsumerState<ClotheDetailScreen> {
  late Clothe clothe;
  bool hasPhotoChanged = false;
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    clothe = widget.clothe;
  }

  void _showAddPhotoPopup() async {
    final result = await showAddClothePhotoPopup(context, widget.clothe.Id);
    if (result == true) {
      final updated = await ref
          .read(clotheNotifierProvider.notifier)
          .getClothe(widget.clothe.Id);
      setState(() {
        clothe = updated;
        hasPhotoChanged = true;
      });
    }
  }

  Future<void> _deletePhoto(String photoId) async {
    try {
      await ref
          .read(clothePhotoNotifierProvider.notifier)
          .deleteClothePhoto(photoId);
      final updated = await ref
          .read(clotheNotifierProvider.notifier)
          .getClothe(widget.clothe.Id);
      setState(() {
        clothe = updated;
        hasPhotoChanged = true;

        if (selectedImageIndex >= updated.ClothePhotos!.length) {
          selectedImageIndex = 0;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete photo: $e")));
    }
  }

  void _showOptionsMenu() {
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
                .getClothe(widget.clothe.Id);

            setState(() {
              clothe = updated;
            });
          }
        },
        onDelete: () async {
          try {
            await ref
                .read(clotheNotifierProvider.notifier)
                .deleteClothe(widget.clothe.Id);

            final userId = ref.read(userProvider)?.Id;
            if (userId != null) {
              await ref.read(authNotifierProvider.notifier).getUser(userId);
              final updatedUser = ref.read(authNotifierProvider).user;
              ref.read(userProvider.notifier).state = updatedUser;
            }

            if (mounted) {
              Navigator.pop(context, {
                'deleted': true,
                'categoryId': widget.clothe.CategoryId,
              });
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
    final displayedClothe = clothe;
    final allImages =
        displayedClothe.ClothePhotos?.map((p) => 'http://10.0.2.2:5000${p.Url}')
                .toList() ??
            [];
    final mainImageUrl = Uri.encodeFull(
      allImages.isNotEmpty
          ? allImages[selectedImageIndex]
          : displayedClothe.MainPhoto,
    );

    return WillPopScope(
      onWillPop: () async {
        if (hasPhotoChanged) {
          final userId = ref.read(userProvider)?.Id;
          if (userId != null) {
            await ref.read(authNotifierProvider.notifier).getUser(userId);
            final updatedUser = ref.read(authNotifierProvider).user;
            ref.read(userProvider.notifier).state = updatedUser;
          }
        }

        Navigator.pop(context, {'updatedClothe': clothe});
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    displayedClothe.Name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ),
              );
            },
            child: Text(
              displayedClothe.Name,
              style: AppTextStyles.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, size: 24.sp),
              onPressed: _showOptionsMenu,
            )
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                mainImageUrl,
                height: 300.h,
                fit: BoxFit.contain,
                errorBuilder: (ctx, _, __) => Icon(
                  Icons.image_not_supported,
                  size: 100.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            if (displayedClothe.ClothePhotos != null) ...[
              Text("More Photos",
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 16.sp)),
              SizedBox(height: 8.h),
              SizedBox(
                height: 80.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayedClothe.ClothePhotos!.length + 1,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    if (index == displayedClothe.ClothePhotos!.length) {
                      return GestureDetector(
                        onTap: _showAddPhotoPopup,
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Icon(Icons.add_a_photo, size: 28.sp),
                        ),
                      );
                    }

                    final photo = displayedClothe.ClothePhotos![index];
                    final thumbUrl =
                        Uri.encodeFull('http://10.0.2.2:5000${photo.Url}');
                    final isSelected = selectedImageIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImageIndex = index;
                        });
                      },
                      onLongPress: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            backgroundColor: Colors.white,
                            title: Text(
                              "Delete Photo",
                              style:
                                  AppTextStyles.title.copyWith(fontSize: 20.sp),
                            ),
                            content: Text(
                              "Are you sure you want to delete this photo?",
                              style:
                                  AppTextStyles.body.copyWith(fontSize: 14.sp),
                            ),
                            actionsPadding:
                                EdgeInsets.only(bottom: 8.h, right: 8.w),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade700),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _deletePhoto(photo.Id);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.network(
                            thumbUrl,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text("Brand",
                style: AppTextStyles.bodyBold.copyWith(fontSize: 16.sp)),
            SizedBox(height: 4.h),
            Text(
              displayedClothe.Brand.isNotEmpty ? displayedClothe.Brand : '-',
              style: AppTextStyles.body,
            ),
            SizedBox(height: 12.h),
            if (displayedClothe.Description?.trim().isNotEmpty == true) ...[
              Text("Description",
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 16.sp)),
              SizedBox(height: 4.h),
              Text(displayedClothe.Description!.trim(),
                  style: AppTextStyles.body),
              SizedBox(height: 12.h),
            ]
          ],
        ),
      ),
    );
  }
}
