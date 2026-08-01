import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'join_startup_screen.dart';
import 'startup_registration_flow_screen.dart';

class StartupLandingScreen extends StatelessWidget {
  const StartupLandingScreen({super.key, this.selectedRole = 'Founder'});

  final String selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B21B6)),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Welcome to the\nStartup Hub',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Create your startup or join an existing team to start collaborating.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF5C6472),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected role: $selectedRole',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B21B6),
                ),
              ),
              const SizedBox(height: 24),
              _ActionCard(
                icon: Icons.rocket_launch_outlined,
                iconBackground: const Color(0xFFE8DBFF),
                title: 'Create Startup',
                description: 'Build your startup profile, invite your team, showcase your products, raise funding and grow your company.',
                primary: true,
                buttonLabel: 'Create Startup',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartupRegistrationFlowScreen(selectedRole: selectedRole),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _ActionCard(
                icon: Icons.apartment_outlined,
                iconBackground: const Color(0xFFE1E8FF),
                title: 'Join Existing Startup',
                description: 'Already working at a startup? Join your company workspace using an invitation link or organizational email.',
                primary: false,
                buttonLabel: 'Join Startup',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinStartupScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.primary,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;
  final bool primary;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFD7CCF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: const Color(0xFF5B21B6), size: 34),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFF58606D),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: primary
                ? ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  )
                : OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
          ),
        ],
      ),
    );
  }
}
