import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'join_startup_screen.dart';
import 'startup_registration_flow_screen.dart';

class StartupLandingScreen extends StatelessWidget {
  const StartupLandingScreen({super.key, this.selectedRole = 'Startup'});

  final String selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: const Color(0xFF6B21D9),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFD8D0EA),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome to the',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF13233B),
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Startup Hub',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B21D9),
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Text(
                            'Create your startup or join an existing team to start collaborating.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.45,
                              color: Color(0xFF5F6676),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _StartupActionCard(
                          icon: Icons.rocket_launch_rounded,
                          iconBackground: const Color(0xFFE9DDFF),
                          title: 'Create Startup',
                          description:
                              'Build your startup profile, invite your team, showcase your products, raise funding and grow your company.',
                          buttonLabel: 'Create Startup',
                          buttonIcon: Icons.arrow_forward_rounded,
                          buttonFilled: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartupRegistrationFlowScreen(
                                  selectedRole: selectedRole,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _StartupActionCard(
                          icon: Icons.apartment_rounded,
                          iconBackground: const Color(0xFFE5EAFB),
                          title: 'Join Existing Startup',
                          description:
                              'Already working at a startup? Join your company’s workspace using an invitation link or organizational email.',
                          buttonLabel: 'Join Startup',
                          buttonFilled: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinStartupScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StartupActionCard extends StatelessWidget {
  const _StartupActionCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonFilled,
    required this.onPressed,
    this.buttonIcon,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;
  final String buttonLabel;
  final bool buttonFilled;
  final VoidCallback onPressed;
  final IconData? buttonIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD8D0EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 30, color: const Color(0xFF6B21D9)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: Color(0xFF13233B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: Color(0xFF5F6676),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: buttonFilled
                ? FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (buttonIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(buttonIcon, size: 18),
                        ],
                      ],
                    ),
                  )
                : OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: Color(0xFFB9AEDC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
