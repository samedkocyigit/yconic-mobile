import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'add_clothe_screen.dart';

class GarderobeScreen extends ConsumerStatefulWidget {
  const GarderobeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GarderobeScreen> createState() => _GarderobeScreenState();
}

class _GarderobeScreenState extends ConsumerState<GarderobeScreen> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider).user;
    final categories = userData?.garderobe.clothesCategory ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(userData?.garderobe.name ?? 'Gardırop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddCategoryDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryListWidget(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                selectedCategoryId = categoryId;
              });
            },
          ),
          Expanded(
            child: ClothesGridWidget(
              clothes: _getSelectedCategoryClothes(categories),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddClotheScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Kategori Ekle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Kategori Adı',
            hintText: 'Örn: Pantolonlar',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // TODO: Kategori ekleme işlemi burada yapılacak
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  List<Clothe> _getSelectedCategoryClothes(List<ClothesCategory> categories) {
    if (selectedCategoryId == null && categories.isNotEmpty) {
      return categories.first.clothes;
    }
    return categories
        .firstWhere(
          (category) => category.id == selectedCategoryId,
          orElse: () => categories.first,
        )
        .clothes;
  }
}

class CategoryListWidget extends StatelessWidget {
  final List<ClothesCategory> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryListWidget({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category.id),
            ),
          );
        },
      ),
    );
  }
}

class ClothesGridWidget extends StatelessWidget {
  final List<Clothe> clothes;

  const ClothesGridWidget({
    Key? key,
    required this.clothes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: clothes.length,
      itemBuilder: (context, index) {
        final clothe = clothes[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: clothe.mainPhoto != null
                    ? Column(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: precacheImage(
                                NetworkImage(
                                  'http://localhost:5169${clothe.mainPhoto}',
                                  headers: const {'Connection': 'keep-alive'},
                                ),
                                context,
                              ).timeout(
                                const Duration(seconds: 10),
                                onTimeout: () => throw TimeoutException(
                                    'Resim yükleme zaman aşımına uğradı'),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Icon(Icons.error_outline,
                                        size: 50, color: Colors.red),
                                  );
                                }
                                return Image.network(
                                  'http://localhost:5169${clothe.mainPhoto}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  headers: const {'Connection': 'keep-alive'},
                                  cacheWidth:
                                      300, // performans için cache boyutu
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clothe.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      clothe.brand,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
