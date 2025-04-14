import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/follow/follow_provider.dart';
import 'package:yconic/presentation/providers/user/public_user_profile_provider.dart';
import 'package:yconic/presentation/screens/home/profile/follow_tab/followers_following_tab_screen.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicUserProfileProvider(userId));
    final currentUser = ref.watch(authNotifierProvider).user!;

    return profileAsync.when(
      loading: () => const Scaffold(),
      error: (e, _) => Scaffold(body: Center(child: Text("Hata: $e"))),
      data: (targetUser) {
        final isSelf = currentUser.Id == targetUser.id;
        final isPrivate = targetUser.isPrivate == true;
        final isFollowing =
            currentUser.Following?.any((u) => u.id == targetUser.id) ?? false;
        final isRequested =
            currentUser.SentFollowRequest?.any((u) => u.id == targetUser.id) ??
                false;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              targetUser.username,
              style: AppTextStyles.title.copyWith(color: Colors.black),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: targetUser.profilePhoto != null
                            ? NetworkImage(
                                'http://10.0.2.2:5000${targetUser.profilePhoto}')
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
                                    builder: (_) => FollowersFollowingTabScreen(
                                      targetUserId: targetUser.id,
                                      initialTabIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: _buildStat(
                                  "Follower", targetUser.followerCount),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FollowersFollowingTabScreen(
                                      targetUserId: targetUser.id,
                                      initialTabIndex: 1,
                                    ),
                                  ),
                                );
                              },
                              child: _buildStat(
                                  "Following", targetUser.followingCount),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text('${targetUser.username}',
                      style: AppTextStyles.title
                          .copyWith(fontWeight: FontWeight.bold)),
                  if (targetUser.bio != null && targetUser.bio!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(targetUser.bio!, style: AppTextStyles.body),
                    ),
                  SizedBox(height: 12.h),
                  if (!isSelf)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final followNotifier =
                              ref.read(followNotifierProvider.notifier);

                          try {
                            if (isFollowing) {
                              await followNotifier.unfollowUser(
                                  currentUser.Id, targetUser.id);
                            } else if (isRequested) {
                              await followNotifier.cancelFollowRequest(
                                  currentUser.Id, targetUser.id);
                            } else {
                              if (isPrivate) {
                                await followNotifier.sendFollowRequest(
                                    currentUser.Id, targetUser.id);
                              } else {
                                await followNotifier.followUser(
                                    currentUser.Id, targetUser.id);
                              }
                            }
                          } catch (e) {
                            debugPrint('Follow error: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing || isRequested
                              ? Colors.white
                              : Colors.blue,
                          foregroundColor: isFollowing || isRequested
                              ? Colors.black
                              : Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 14.h, horizontal: 24.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r)),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: Text(
                          isFollowing
                              ? 'Unfollow'
                              : isRequested
                                  ? 'Requested'
                                  : 'Follow',
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Center(
                    child: Text("Combines (coming soon)",
                        style: AppTextStyles.body),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
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
