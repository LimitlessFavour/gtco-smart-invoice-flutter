import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/auth/auth_background.dart';
import 'login_screen.dart';
import '../../widgets/common/app_text.dart';
import 'setup_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../services/logger_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  bool _acceptedTerms = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        companyName: _companyNameController.text.trim(),
      );

      if (!mounted) return;

      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error!)),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupScreen()),
      );
    } catch (e) {
      LoggerService.error('Signup error', error: e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during signup. Please try again.'),
        ),
      );
    }
  }

  void _handleGoogleSignIn() async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.signInWithGoogle();

      if (!mounted) return;

      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error!)),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupScreen()),
      );
    } catch (e) {
      LoggerService.error('Google sign-in error', error: e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred during Google sign-in. Please try again.'),
        ),
      );
    }
  }

  void _handleAppleSignIn() async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.signInWithApple();

      if (!mounted) return;

      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error!)),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupScreen()),
      );
    } catch (e) {
      LoggerService.error('Apple sign-in error', error: e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('An error occurred during Apple sign-in. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: context.watch<AuthProvider>().isLoading,
        child: AuthBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                    const Gap(16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'johndoe@email.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      isPassword: _obscureText,
                      hint: '*******',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }
                        if (value!.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
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
                      onPressed: _acceptedTerms ? _handleSignup : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE04403),
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
                      onPressed: _handleGoogleSignIn,
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
                      onPressed: _handleAppleSignIn,
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
          ),
        ),
      ),
    );
  }
}
