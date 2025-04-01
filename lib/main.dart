import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/screens/auth/login_screen.dart';
import 'package:yconic/presentation/screens/auth/register_screen.dart';
import 'package:yconic/presentation/screens/home/home_screen.dart';
import 'package:yconic/presentation/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Yconic',
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/home': (context) => HomeScreen(),
          },
        );
      },
    );
  }
}
