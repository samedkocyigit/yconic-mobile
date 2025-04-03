import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + Motto
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/yconic-text.png',
                    width: 200.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 4.h),
                  Image.asset(
                    'assets/images/single-line-motto.png',
                    width: 110.w,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: 36.h),

              // Form Fields
              _buildTextField(controller: emailController, hintText: 'Email'),
              SizedBox(height: 16.h),
              _buildTextField(
                  controller: usernameController, hintText: 'Username'),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: passwordConfirmController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: 24.h),

              // Register Button or Loader
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : _buildButton(
                      text: 'Register',
                      onPressed: () async {
                        if (emailController.text.trim().isEmpty ||
                            usernameController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty ||
                            passwordConfirmController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill in all fields")),
                          );
                          return;
                        }

                        if (passwordController.text.trim() !=
                            passwordConfirmController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        await authNotifier.register(
                          emailController.text.trim(),
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Registration Successful!")),
                        );

                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
              SizedBox(height: 24.h),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              // Error message
              if (authState.error != null)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
