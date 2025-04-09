import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/screens/home/profile/account_option/options/change_password_screen.dart';
import 'options/edit_account_screen.dart';
import 'options/change_privacy_screen.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class AccountOptionsScreen extends ConsumerWidget {
  const AccountOptionsScreen({super.key});

  Widget _optionTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Account Options", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _optionTile(
            context,
            "Edit Account",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditAccountScreen()),
              );
            },
          ),
          Divider(),
          _optionTile(
            context,
            "Change Privacy",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePrivacyScreen()),
              );
            },
          ),
          Divider(),
          _optionTile(
            context,
            "Change Password",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),
          Divider(),
          _optionTile(
            context,
            "Log Out",
            () async {
              await ref.read(authNotifierProvider.notifier).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
