import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/user/update_user_account_dto.dart';
import 'package:yconic/data/enums/persona_types.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each input
  late TextEditingController _phoneController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _birthdayController;

  DateTime? _selectedBirthday;
  late PersonaTypes _selectedPersona;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authNotifierProvider).user!;
    _phoneController =
        TextEditingController(text: currentUser.PhoneNumber ?? '');
    _weightController = TextEditingController(
        text: currentUser.Weight != null ? currentUser.Weight.toString() : '');
    _heightController = TextEditingController(
        text: currentUser.Height != null ? currentUser.Height.toString() : '');

    // Set up birthday controller and date value
    _selectedBirthday = currentUser.Birthday;
    _birthdayController = TextEditingController(
      text: _selectedBirthday != null
          ? "${_selectedBirthday!.day.toString().padLeft(2, '0')}/${_selectedBirthday!.month.toString().padLeft(2, '0')}/${_selectedBirthday!.year}"
          : "",
    );

    // Handle persona conversion. Assume UserPersonaId is a string representing an integer.
    int personaIndex = 0;
    if (currentUser.UserPersonaId != null) {
      personaIndex = int.tryParse(currentUser.UserPersonaId!) ?? 0;
      if (personaIndex < 0 || personaIndex >= PersonaTypes.values.length) {
        personaIndex = 0;
      }
    }
    _selectedPersona = PersonaTypes.values[personaIndex];
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // Date picker for birthday – when a user taps the field, update both controller and state.
  Future<void> _pickBirthday() async {
    final initialDate = _selectedBirthday ?? DateTime(2000, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthday = pickedDate;
        _birthdayController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  // _updateAccount builds the DTO and triggers your use case
  Future<void> _updateAccount() async {
    if (_formKey.currentState?.validate() != true) return;
    final phone = _phoneController.text.trim();
    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());

    // Construct a UTC birthday using only the year, month, and day.
    final birthday = _selectedBirthday != null
        ? DateTime.utc(
            _selectedBirthday!.year,
            _selectedBirthday!.month,
            _selectedBirthday!.day,
          )
        : null;

    final dto = UpdateUserAccountDto(
      phoneNumber: phone,
      weight: weight,
      height: height,
      birthday: birthday,
      // Send persona as the index of the selected enum.
      personaType: _selectedPersona.index,
    );

    try {
      await ref.read(authNotifierProvider.notifier).updateUserAccount(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account details updated!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating account: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final birthdayHint = _birthdayController.text.isNotEmpty
        ? _birthdayController.text
        : "Select your birthday";

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Account", style: AppTextStyles.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Birthday field (read-only)
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  hintText: birthdayHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                readOnly: true,
                onTap: _pickBirthday,
              ),
              SizedBox(height: 16.h),
              // Weight field
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),
              // Height field
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),
              // Phone number field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              // Persona dropdown using PersonaTypes enum.
              DropdownButtonFormField<PersonaTypes>(
                value: _selectedPersona,
                items: PersonaTypes.values.map((pt) {
                  return DropdownMenuItem<PersonaTypes>(
                    value: pt,
                    child: Text(
                      pt.displayValue,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }).toList(),
                onChanged: (PersonaTypes? newVal) {
                  if (newVal != null) {
                    setState(() {
                      _selectedPersona = newVal;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'User Persona',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _updateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
