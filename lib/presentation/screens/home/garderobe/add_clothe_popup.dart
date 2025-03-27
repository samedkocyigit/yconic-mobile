import 'package:flutter/material.dart';
import 'package:yconic/core/theme/app_text_styles.dart';

class AddClothePopup extends StatefulWidget {
  const AddClothePopup({Key? key}) : super(key: key);

  @override
  _AddClothePopupState createState() => _AddClothePopupState();
}

class _AddClothePopupState extends State<AddClothePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  // Ek alanlar: Fotoğraf seçimi, kategori seçimi vb. eklenebilir.

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Klavye açıldığında altta kalmaması için
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Clothe", style: AppTextStyles.title),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Clothe Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: brandController,
                decoration: InputDecoration(
                  labelText: "Brand",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Enter a brand" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Send form data to backend via provider/use-case
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Clothe",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddClothePopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: const AddClothePopup(),
          ));
}
