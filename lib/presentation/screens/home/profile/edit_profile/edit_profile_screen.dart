import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/data/dtos/user/update_user_personal_dto.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/user/all_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authNotifierProvider).user!;
    _usernameController = TextEditingController(text: currentUser.Username);
    _nameController = TextEditingController(text: currentUser.Name ?? '');
    _surnameController = TextEditingController(text: currentUser.Surname ?? '');
    _bioController = TextEditingController(text: currentUser.Bio ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() != true) return;

    final newUsername = _usernameController.text.trim();
    final newName = _nameController.text.trim();
    final newSurname = _surnameController.text.trim();
    final newBio = _bioController.text.trim();

    // Build the DTO using the updated fields.
    final dto = UpdateUserPersonalDto(
      username: newUsername,
      name: newName,
      surname: newSurname,
      bio: newBio,
    );

    try {
      await ref.read(authNotifierProvider.notifier).updateUserPersonal(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the list of all users for username uniqueness. (Assume it returns List<SimpleUser>.)
    final allUsers = ref.watch(allUsersProvider);
    final currentUser = ref.read(authNotifierProvider).user!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Edit Profile",
            style: AppTextStyles.title.copyWith(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Username Field with uniqueness validation.
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username';
                  }
                  final newUsername = value.trim().toLowerCase();
                  final currentUsername = currentUser.Username.toLowerCase();
                  // If the username has been changed, check if it already exists.
                  if (newUsername != currentUsername &&
                      allUsers.any((user) =>
                          user.username.toLowerCase() == newUsername)) {
                    return 'This username is taken';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
              ),
              SizedBox(height: 16.h),
              // Surname Field
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
              ),
              SizedBox(height: 16.h),
              // Bio Field
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text("Save",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
