import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class ChangePrivacyScreen extends ConsumerStatefulWidget {
  const ChangePrivacyScreen({super.key});

  @override
  ConsumerState<ChangePrivacyScreen> createState() =>
      _ChangePrivacyScreenState();
}

class _ChangePrivacyScreenState extends ConsumerState<ChangePrivacyScreen> {
  bool? _isPrivate;

  @override
  void initState() {
    super.initState();
    // Initialize _isPrivate using the current user's privacy setting.
    final currentUser = ref.read(authNotifierProvider).user!;
    _isPrivate = currentUser.IsPrivate;
  }

  Future<void> _togglePrivacy() async {
    try {
      // Call your updated changePrivacy method via the AuthNotifier extension.
      await ref.read(authNotifierProvider.notifier).changePrivacy();
      // Retrieve the updated user state.
      final updatedUser = ref.read(authNotifierProvider).user;
      setState(() {
        _isPrivate = updatedUser?.IsPrivate;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Privacy settings updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating privacy: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Change Privacy",
            style: AppTextStyles.title.copyWith(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Toggle your account privacy setting.",
              style: AppTextStyles.body.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Private Account",
                  style: AppTextStyles.body.copyWith(fontSize: 16.sp),
                ),
                Switch(
                  value: _isPrivate ?? false,
                  onChanged: (val) {
                    _togglePrivacy();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
