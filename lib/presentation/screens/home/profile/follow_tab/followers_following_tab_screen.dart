import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/user/public_user_profile_provider.dart';
import 'package:yconic/presentation/providers/follow/follow_provider.dart';

class FollowersFollowingTabScreen extends ConsumerStatefulWidget {
  final String? targetUserId;
  final int initialTabIndex;

  const FollowersFollowingTabScreen({
    super.key,
    this.targetUserId,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<FollowersFollowingTabScreen> createState() =>
      _FollowersFollowingTabScreenState();
}

class _FollowersFollowingTabScreenState
    extends ConsumerState<FollowersFollowingTabScreen>
    with SingleTickerProviderStateMixin {
  String _searchText = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    // Listen for changes so the UI rebuilds.
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).user;
    final isSelf =
        widget.targetUserId == null || widget.targetUserId == currentUser?.Id;

    final viewedUserAsync = !isSelf
        ? ref.watch(publicUserProfileProvider(widget.targetUserId!))
        : const AsyncValue.data(null);

    if (!isSelf && viewedUserAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final viewedUser = isSelf
        ? null
        : viewedUserAsync.maybeWhen(
            data: (u) => u,
            orElse: () => null,
          );

    final followers =
        isSelf ? currentUser?.Followers ?? [] : viewedUser?.followers ?? [];
    final following =
        isSelf ? currentUser?.Following ?? [] : viewedUser?.following ?? [];

    final currentUserFollowingIds =
        currentUser?.Following?.map((e) => e.id).toSet() ?? {};
    final sentRequests =
        currentUser?.SentFollowRequest?.map((e) => e.id).toSet() ?? {};

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            isSelf
                ? (currentUser?.Username ?? "Users")
                : (viewedUser?.username ?? "Users"),
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: "Followers",
              ),
              Tab(text: "Following"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                onChanged: (value) => setState(() => _searchText = value),
                decoration: InputDecoration(
                  hintText: "Search user...",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First tab is Followers.
                  _buildUserList(
                    followers,
                    currentUser,
                    currentUserFollowingIds,
                    sentRequests,
                    isFollowersTab: true,
                  ),
                  _buildUserList(
                    following,
                    currentUser,
                    currentUserFollowingIds,
                    sentRequests,
                    isFollowersTab: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
    List<SimpleUser> users,
    dynamic currentUser,
    Set<String> currentUserFollowingIds,
    Set<String> sentRequests, {
    required bool isFollowersTab,
  }) {
    final filtered = users
        .where(
            (u) => u.username.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("User not found."));
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = filtered[index];
        final isSelf = user.id == currentUser.Id;
        final isFollowing = currentUserFollowingIds.contains(user.id);
        final isRequested = sentRequests.contains(user.id);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.profilePhoto != null
                ? NetworkImage(user.profilePhoto!)
                : const AssetImage("assets/default_avatar.jpg")
                    as ImageProvider,
          ),
          title: Text(
            user.username.isNotEmpty ? user.username : "(no username)",
          ),
          onTap: () {
            if (isSelf) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
                arguments: 4,
              );
            } else {
              Navigator.pushNamed(
                context,
                '/user-profile',
                arguments: user.id,
              );
            }
          },
          trailing: isSelf
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () async {
                          final followNotifier =
                              ref.read(followNotifierProvider.notifier);
                          final currentUserId = currentUser.Id!;
                          final targetUserId = user.id;

                          if (isFollowing) {
                            await followNotifier.unfollowUser(
                                currentUserId, targetUserId);
                          } else if (isRequested) {
                            await followNotifier.cancelFollowRequest(
                                currentUserId, targetUserId);
                          } else {
                            if (user.isPrivate) {
                              await followNotifier.sendFollowRequest(
                                  currentUserId, targetUserId);
                            } else {
                              await followNotifier.followUser(
                                  currentUserId, targetUserId);
                            }
                          }

                          final targetUserIdCopy = widget.targetUserId;
                          if (!isSelf && mounted && targetUserIdCopy != null) {
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                if (mounted) {
                                  ref.invalidate(publicUserProfileProvider(
                                      targetUserIdCopy));
                                }
                              },
                            );
                          }
                          // No need to invalidate authNotifierProvider.
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: (!isFollowing && !isRequested)
                              ? Colors.blue
                              : Colors.white,
                          foregroundColor: (!isFollowing && !isRequested)
                              ? Colors.white
                              : Colors.black,
                          side: BorderSide(
                            color: (!isFollowing && !isRequested)
                                ? Colors.blue
                                : Colors.grey.shade400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isFollowing
                              ? "Unfollow"
                              : isRequested
                                  ? "Requested"
                                  : "Follow",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Show remove follower button only when:
                    // - We are in the Followers tab (isFollowersTab true)
                    // - And you're viewing your own profile (widget.targetUserId is null)
                    if (isFollowersTab && widget.targetUserId == null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                "Remove Follower",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to remove this follower?",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              actionsPadding:
                                  EdgeInsets.only(bottom: 8.h, right: 8.w),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(
                                    "Remove",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
        );
      },
    );
  }
}
