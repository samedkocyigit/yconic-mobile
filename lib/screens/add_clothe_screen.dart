import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/providers/garderobe_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class AddClotheScreen extends ConsumerStatefulWidget {
  final String? categoryId;

  const AddClotheScreen({
    Key? key,
    this.categoryId,
  }) : super(key: key);

  @override
  ConsumerState<AddClotheScreen> createState() => _AddClotheScreenState();
}

class _AddClotheScreenState extends ConsumerState<AddClotheScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider).user;
    final categories = userData?.garderobe.clothesCategory ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Kıyafet Ekle')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.categoryId == null) ...[
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Lütfen bir kategori seçin' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Kıyafet Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Bu alan zorunludur' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marka',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Bu alan zorunludur' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama (Opsiyonel)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_library),
          label: const Text('Fotoğraf Seç'),
        ),
        if (_image != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              '${ApiConstants.baseUrl}${_image!.path}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text('Resim yüklenemedi'),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf seçilemedi: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir fotoğraf seçin')),
        );
        return;
      }

      try {
        // Loading göster
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Kıyafet ekle
        await ref.read(authenticatedApiServiceProvider).addClothe(
              name: _nameController.text,
              brand: _brandController.text,
              categoryId: _selectedCategoryId ?? widget.categoryId!,
              photoPath: _image!.path,
              description: _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
            );

        // Gardırop verilerini güncelle
        final newGarderobeData = await ref
            .read(authenticatedApiServiceProvider)
            .refreshGarderobeData();

        // Loading'i kapat ve ekranı kapat
        if (mounted) {
          Navigator.pop(context); // Loading dialog'u kapat
          Navigator.pop(context); // Add Clothe ekranını kapat

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kıyafet başarıyla eklendi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Hata durumunda loading'i kapat
        if (mounted) {
          Navigator.pop(context); // Loading dialog'u kapat

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kıyafet eklenemedi: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
