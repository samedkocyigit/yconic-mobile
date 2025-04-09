import 'package:flutter/material.dart';
import 'package:yconic/presentation/screens/auth/login_screen.dart';
import 'package:yconic/presentation/screens/auth/register_screen.dart';
import 'package:yconic/presentation/screens/home/explore/user_profile_screen.dart';
import 'package:yconic/presentation/screens/home/home_screen.dart';
import 'package:yconic/presentation/screens/home/profile/follow_tab/followers_following_tab_screen.dart';
import 'package:yconic/presentation/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/home':
        final index = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => HomeScreen(initialIndex: index));

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case '/user-profile':
        final userId = settings.arguments as String?;
        if (userId == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("Kullanıcı bulunamadı")),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => UserProfileScreen(userId: userId),
          settings: settings,
        );

      case '/followers-following':
        final args = settings.arguments;
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => FollowersFollowingTabScreen(initialTabIndex: args),
          );
        } else if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => FollowersFollowingTabScreen(
              targetUserId: args['targetUserId'],
              initialTabIndex: args['initialTabIndex'] ?? 0,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("Geçersiz yönlendirme verisi")),
            ),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
