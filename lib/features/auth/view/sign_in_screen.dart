import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/view/home_screen.dart';
import '../../startup/startup.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'forgot_password_screen.dart';
import 'guest_explore_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F5FF),
              Color(0xFFF3F7FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -26,
                right: -28,
                child: _GlowBlob(
                  color: AppColors.primary.withOpacity(0.12),
                  size: 170,
                ),
              ),
              Positioned(
                top: 168,
                left: -24,
                child: _GlowBlob(
                  color: const Color(0xFF2F80ED).withOpacity(0.10),
                  size: 120,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final canPop = Navigator.of(context).canPop();
                            if (canPop) {
                              Navigator.pop(context);
                            } else {
                              // Came from splash via pushReplacement — go back to it
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen(),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text('Create account'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.lock_person_rounded,
                              color: AppColors.primary,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Sign in to continue, or create a new account if you are here for the first time.',
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'name@company.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.key_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 12),
                           SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSigningIn
                                  ? null
                                  : () async {
                                      final messenger = ScaffoldMessenger.of(context);
                                      final navigator = Navigator.of(context);
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text;

                                      if (email.isEmpty || password.isEmpty) {
                                        _showMessage(
                                          messenger,
                                          'Enter your email and password.',
                                        );
                                        return;
                                      }

                                      setState(() => _isSigningIn = true);

                                      try {
                                        final authVM = ref.read(authViewModelProvider.notifier);
                                        final errorMsg = await authVM.signIn(
                                          email: email,
                                          password: password,
                                        );

                                        if (errorMsg != null) {
                                          if (!mounted) return;
                                          _showMessage(messenger, errorMsg);
                                          return;
                                        }

                                        if (!mounted) return;
                                        final session = ref.read(authViewModelProvider).session;
                                        if (session == null) return;

                                        final destination = session.isStartupRole
                                            ? (session.startupName != null &&
                                                      session.startupName!.isNotEmpty
                                                  ? StartupDashboardScreen(
                                                      startupName: session.startupName!,
                                                    )
                                                  : StartupLandingScreen(
                                                      selectedRole: session.role,
                                                    ))
                                            : const HomeScreen();

                                        navigator.pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => destination,
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isSigningIn = false);
                                        }
                                      }
                                    },
                              child: _isSigningIn
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GuestExploreScreen(),
                                  ),
                                );
                              },
                              child: const Text('Continue as Guest'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      onPressed: () =>
                          _showUnavailable(context, 'Google sign-in'),
                    ),
                    const SizedBox(height: 14),
                    _buildSocialButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      onPressed: () =>
                          _showUnavailable(context, 'Apple sign-in'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Stack(
        children: [
          Align(alignment: Alignment.centerLeft, child: Icon(icon, size: 24)),
          Align(alignment: Alignment.center, child: Text(label)),
        ],
      ),
    );
  }

  void _showUnavailable(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature is not available yet.')));
  }

  void _showMessage(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
