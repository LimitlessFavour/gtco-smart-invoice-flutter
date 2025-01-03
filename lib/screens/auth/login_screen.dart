import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/common/app_text.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(32),
              const GtcoLogo(),
              const Gap(32),
              AppText.heading(
                'Welcome Back!',
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              AppText.subheading(
                'Login to your account',
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                controller: _passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFFE84C3D),
                      ),
                      const AppText('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: const AppText(
                      'Forgot Password?',
                      color: Color(0xFFE84C3D),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle login
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84C3D),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AppText.button('Login'),
              ),
              const Gap(24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppText(
                      'OR',
                      color: Colors.grey[600],
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const Gap(24),
              OutlinedButton.icon(
                onPressed: () {
                  // Handle Google sign in
                },
                icon: Image.asset('assets/images/google.png', height: 24),
                label: const AppText(
                  'Continue with Google',
                  color: Colors.black,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Gap(16),
              OutlinedButton.icon(
                onPressed: () {
                  // Handle Apple sign in
                },
                icon: const Icon(Icons.apple, color: Colors.black),
                label: const AppText(
                  'Continue with Apple',
                  color: Colors.black,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppText("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const AppText(
                      'Sign Up',
                      color: Color(0xFFE84C3D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
