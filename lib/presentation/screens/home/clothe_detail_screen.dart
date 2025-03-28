import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/clothe/clothe_provider.dart';
import 'package:yconic/presentation/providers/clothe_photo/clothe_photo_provider.dart';
import 'package:yconic/presentation/screens/home/garderobe/add_clothe_photos.dart';

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
        title: Text(displayedClothe.Name, style: AppTextStyles.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: displayedClothe.ClothePhotos!.length + 1,
                itemBuilder: (context, index) {
                  if (index == displayedClothe.ClothePhotos!.length) {
                    return GestureDetector(
                      onTap: _showAddPhotoPopup,
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Icon(Icons.camera_alt_outlined,
                            color: Colors.grey),
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
                          title: const Text("Delete Photo"),
                          content: const Text(
                              "Are you sure you want to delete this photo?"),
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
                        try {
                          await ref
                              .read(clothePhotoNotifierProvider.notifier)
                              .deleteClothePhoto(photo.Id);
                          setState(() {
                            displayedClothe.ClothePhotos!.removeAt(index);
                            if (selectedImageIndex >=
                                displayedClothe.ClothePhotos!.length) {
                              selectedImageIndex = 0;
                            }
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Failed to delete photo: $e")),
                          );
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade400,
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
                          errorBuilder: (ctx, _, __) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
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
          Text("Description", style: AppTextStyles.bodyBold),
          Text(displayedClothe.Description ?? '-', style: AppTextStyles.body),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
