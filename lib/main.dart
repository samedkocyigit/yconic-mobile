import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        final authStore = ref.read(authProvider);
        final isAuthenticated = authStore.isAuthenticated == true;

        if (settings.name == '/login' || settings.name == '/register') {
          return MaterialPageRoute(
            builder: (context) => settings.name == '/login'
                ? const LoginPage()
                : const RegisterPage(),
          );
        }

        if (!isAuthenticated) {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        }

        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (context) => const LoginPage());
        }
      },
    );
  }
}
