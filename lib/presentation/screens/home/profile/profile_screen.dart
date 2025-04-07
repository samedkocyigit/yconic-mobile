import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/screens/auth/login_screen.dart';
import 'package:yconic/presentation/screens/home/profile/followers_following_tab_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final user = ref.watch(authNotifierProvider).user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜST KISIM: Profil Foto, Username, Sayılar
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: user.ProfilePhoto != null
                        ? NetworkImage(user.ProfilePhoto!)
                        : const AssetImage("assets/default_avatar.jpg")
                            as ImageProvider,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const FollowersFollowingTabScreen(
                                        initialTabIndex: 0),
                              ),
                            );
                          },
                          child:
                              _buildStat("Follower", user.FollowerCount ?? 0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const FollowersFollowingTabScreen(
                                        initialTabIndex: 1),
                              ),
                            );
                          },
                          child:
                              _buildStat("Following", user.FollowingCount ?? 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(user.Username,
                  style: AppTextStyles.title
                      .copyWith(fontWeight: FontWeight.bold)),
              if (user.Bio != null && user.Bio!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(user.Bio!, style: AppTextStyles.body),
                ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: Text("Edit Profile",
                      style: AppTextStyles.body.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await authNotifier.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text("Çıkış Yap", style: AppTextStyles.body),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text("$value", style: AppTextStyles.bodyBold.copyWith(fontSize: 16.sp)),
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 14.sp)),
      ],
    );
  }
}
