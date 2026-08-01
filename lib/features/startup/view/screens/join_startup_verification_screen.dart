import 'package:flutter/material.dart';

import '../../model/startup_models.dart';
import 'join_startup_status_screen.dart';

class JoinStartupVerificationScreen extends StatelessWidget {
  const JoinStartupVerificationScreen({super.key, required this.startup});

  final SuggestedStartup startup;

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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Identity & Employment Verification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please verify your identity before joining this startup.',
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: Color(0xFF5D6472),
                ),
              ),
              const SizedBox(height: 18),
              _verificationCard(
                title: 'Government ID',
                subtitle: 'Passport, National ID, Driving License',
                buttonLabel: 'Replace',
                statusLabel: 'Uploaded',
                icon: Icons.badge_outlined,
                onPressed: () {},
              ),
              _verificationCard(
                title: 'Employment Proof',
                subtitle: 'Offer Letter, Appointment Letter, Employee ID',
                buttonLabel: 'Upload Document',
                icon: Icons.work_outline,
                onPressed: () {},
              ),
              _verificationCard(
                title: 'Professional Verification',
                subtitle: 'LinkedIn Profile, Portfolio, Resume',
                buttonLabel: 'Add Information',
                icon: Icons.link_outlined,
                onPressed: () {},
              ),
              _verificationCard(
                title: 'Education Verification',
                subtitle: 'Degree Certificate, Student ID',
                buttonLabel: 'Upload',
                icon: Icons.school_outlined,
                optional: true,
                onPressed: () {},
              ),
              _verificationCard(
                title: 'Profile Selfie',
                subtitle: 'Capture Live Photo, Face Verification',
                buttonLabel: 'Open Camera',
                icon: Icons.camera_alt_outlined,
                onPressed: () {},
              ),
              _verificationCard(
                title: 'Additional Documents',
                subtitle: 'Supporting identity or work proof',
                buttonLabel: 'Add More',
                icon: Icons.folder_open_outlined,
                optional: true,
                onPressed: () {},
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'By submitting, you agree to our Security Policies.',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFD9D5E9))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: Color(0xFFB7B5C9)),
                    foregroundColor: const Color(0xFF3B3B4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JoinStartupStatusScreen(startup: startup),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Verification',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verificationCard({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onPressed,
    String? statusLabel,
    bool optional = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD7D5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF5B21B6), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D),
                            ),
                          ),
                        ),
                        if (statusLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F7ED),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Uploaded',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F9B54),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF5D6472),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      optional ? 'Optional' : 'Required',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: optional
                            ? const Color(0xFF8C8FA0)
                            : const Color(0xFF5B21B6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              foregroundColor: const Color(0xFF5B21B6),
              side: const BorderSide(color: Color(0xFF5B21B6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
