import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/follow/follow_provider.dart';

class FollowRequestsScreen extends ConsumerWidget {
  const FollowRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).user!;
    // Assume currentUser.receivedFollowRequests exists as a List<SimpleUser>
    final List<SimpleUser>? requests = currentUser.RecievedFollowRequest;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Follow Requests",
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: requests!.isEmpty
          ? Center(
              child: Text(
                "No follow requests",
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          : ListView.separated(
              itemCount: requests.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final requester = requests[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: requester.profilePhoto != null
                        ? NetworkImage(requester.profilePhoto!)
                        : const AssetImage("assets/default_avatar.jpg")
                            as ImageProvider,
                  ),
                  title: Text(
                    requester.username.isNotEmpty
                        ? requester.username
                        : "(no username)",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(followNotifierProvider.notifier)
                                .acceptFollowRequest(
                                    currentUser.Id, requester.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Follow request accepted")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Error accepting request")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Accept",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(followNotifierProvider.notifier)
                                .declineFollowRequest(
                                    currentUser.Id, requester.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Follow request declined")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Error declining request")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Decline",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
