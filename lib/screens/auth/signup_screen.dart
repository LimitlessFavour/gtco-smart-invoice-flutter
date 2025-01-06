import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/auth/auth_background.dart';
import 'login_screen.dart';
import '../../widgets/common/app_text.dart';
import 'setup_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedTerms = false;
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
                'Sign up to SmartInvoice',
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
              ),
              const Gap(16),
              CustomTextField(
                label: 'Password',
                hint: '********',
                isPassword: true,
                controller: _passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              const Gap(16),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFE04403),
                  ),
                  Expanded(
                    child: AppText(
                      'I confirm that i have read and agree to SmartInvoice Terms of Service and Privacy Policy',
                      size: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: _acceptedTerms
                    ? () {
                        // if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetupScreen(),
                          ),
                        );
                        // }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AppText.button('Get Started'),
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
                  'Sign in with Google',
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
                  'Sign in with Apple',
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
                  const AppText('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const AppText(
                      'Log In',
                      color: Color(0xFFE04403),
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
