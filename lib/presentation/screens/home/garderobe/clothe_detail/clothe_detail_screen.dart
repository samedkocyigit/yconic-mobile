import 'package:flutter/material.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';
import 'package:yconic/presentation/screens/home/garderobe/clothe_detail/popups/add_clothe_photos.dart';
import 'package:yconic/presentation/screens/home/garderobe/popups/edit_clothe_popup.dart';

class ClotheDetailScreen extends ConsumerStatefulWidget {
  late Clothe clothe;

  ClotheDetailScreen({super.key, required this.clothe});

  @override
  ConsumerState<ClotheDetailScreen> createState() => _ClotheDetailScreenState();
}

class _ClotheDetailScreenState extends ConsumerState<ClotheDetailScreen> {
  late Clothe clothe;
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
      });
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit"),
              onTap: () async {
                Navigator.pop(context); // bottom sheet kapat

                final result =
                    await showEditClothePopup(context, ref, widget.clothe);

                if (result == true) {
                  final updated = await ref
                      .read(clotheNotifierProvider.notifier)
                      .getClothe(widget.clothe.Id);

                  setState(() {
                    clothe = updated;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Clothing"),
                    content: const Text(
                        "Are you sure you want to delete this clothing item?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref
                      .read(clotheNotifierProvider.notifier)
                      .deleteClothe(widget.clothe.Id);

                  final userId = ref.read(userProvider)?.Id;
                  if (userId != null) {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .getUser(userId);
                    final updatedUser = ref.read(authNotifierProvider).user;
                    ref.read(userProvider.notifier).state = updatedUser;
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context, {
                      'deleted': true,
                      'categoryId': widget.clothe.CategoryId,
                    });
                  }
                }
              },
            ),
          ],
        ),
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

    return Scaffold(
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
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptionsMenu,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              mainImageUrl,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (ctx, _, __) => const Icon(
                Icons.image_not_supported,
                size: 100,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (displayedClothe.ClothePhotos != null) ...[
            Text("More Photos", style: AppTextStyles.bodyBold),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: displayedClothe.ClothePhotos!.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == displayedClothe.ClothePhotos!.length) {
                    return GestureDetector(
                      onTap: _showAddPhotoPopup,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 28),
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          thumbUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text("Brand", style: AppTextStyles.bodyBold),
          Text(displayedClothe.Brand.isNotEmpty ? displayedClothe.Brand : '-',
              style: AppTextStyles.body),
          const SizedBox(height: 12),
          if (displayedClothe.Description?.trim().isNotEmpty == true) ...[
            Text("Description", style: AppTextStyles.bodyBold),
            Text(displayedClothe.Description!.trim(),
                style: AppTextStyles.body),
            const SizedBox(height: 12),
          ]

          // if (description != null && description.isNotEmpty) ...[
          //   Text("Description", style: AppTextStyles.bodyBold),
          //   Text(description, style: AppTextStyles.body),
          //   const SizedBox(height: 24),
          // ]
        ],
      ),
    );
  }
}
