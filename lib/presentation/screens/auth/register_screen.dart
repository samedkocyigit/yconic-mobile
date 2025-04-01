import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/screens/auth/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32.h),
              _buildTextField(emailController, 'Email'),
              _buildTextField(usernameController, 'Username'),
              _buildTextField(passwordController, 'Password', obscure: true),
              _buildTextField(passwordConfirmController, 'Confirm Password',
                  obscure: true),
              // _buildTextField(
              //   birthdayController,
              //   'Birthday',
              //   readOnly: true,
              //   suffixIcon: IconButton(
              //     icon: const Icon(Icons.calendar_today, color: Colors.white70),
              //     onPressed: () async {
              //       final pickedDate = await showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now()
              //             .subtract(const Duration(days: 365 * 18)),
              //         firstDate: DateTime(1900),
              //         lastDate: DateTime.now(),
              //       );
              //       if (pickedDate != null) {
              //         birthdayController.text =
              //             pickedDate.toIso8601String().split('T').first;
              //       }
              //     },
              //   ),
              // ),
              SizedBox(height: 24.h),
              authState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () async {
                        try {
                          // final birthday =
                          //     DateTime.parse(birthdayController.text.trim());
                          await authNotifier.register(
                              emailController.text.trim(),
                              usernameController.text.trim(),
                              passwordController.text.trim());

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Registration Successful!")),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (authState.error != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscure = false, bool readOnly = false, Widget? suffixIcon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Colors.white30),
          ),
        ),
      ),
    );
  }
}
