import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Kategori Ekle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Kategori Adı',
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
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Ekle'),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
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

        // Kategori ekle
        await ref.read(authenticatedApiServiceProvider).addCategory(
              name: _nameController.text,
              description: _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
            );

        // Gardırop verilerini güncelle
        final newGarderobeData = await ref
            .read(authenticatedApiServiceProvider)
            .refreshGarderobeData();

        // Loading'i kapat ve dialog'u kapat
        if (mounted) {
          Navigator.pop(context); // Loading dialog'u kapat
          Navigator.pop(context); // Add Category dialog'u kapat

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kategori başarıyla eklendi'),
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
              content: Text('Kategori eklenemedi: $e'),
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
    _descriptionController.dispose();
    super.dispose();
  }
}
