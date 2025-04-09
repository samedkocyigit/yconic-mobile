import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'follow_requests_screen.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).user;
    final isPrivate = currentUser?.IsPrivate ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('For You', style: TextStyle(fontSize: 20.sp)),
        actions: [
          if (isPrivate)
            IconButton(
              icon: Icon(Icons.favorite_outline, size: 24.sp),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FollowRequestsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Welcome to Yconic!',
          style: TextStyle(fontSize: 24.sp),
        ),
      ),
    );
  }
}
