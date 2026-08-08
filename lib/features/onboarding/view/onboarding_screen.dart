import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../auth/view/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;
  late final AnimationController _enterController;

  late final Animation<double> _fade;
  late final Animation<double> _pulse;
  late final Animation<double> _enterFade;
  late final Animation<double> _enterScale;
  late final Animation<Offset> _enterSlide;

  static const _modes = [
    ('Startup', Icons.rocket_launch_rounded, Color(0xFF7C3AED)),
    ('Events', Icons.event_rounded, Color(0xFF2563EB)),
    ('Community', Icons.groups_rounded, Color(0xFF059669)),
    ('Investor', Icons.trending_up_rounded, Color(0xFFD97706)),
    ('Career', Icons.work_rounded, Color(0xFFDC2626)),
  ];

  @override
  void initState() {
    super.initState();

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _enterFade = CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _enterScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
    );
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _enterController.forward();
    });
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  void _getStarted() async {
    // Always call .request() — iOS/Android will only show the dialog
    // when status is notDetermined. Already granted/denied states are
    // handled silently by the OS.
    final status = await Permission.notification.request();

    if (!mounted) return;

    // If permanently denied, offer to open Settings
    if (status.isPermanentlyDenied) {
      _showPermissionDialog();
      return;
    }

    _navigateToSignIn();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Enable Notifications'),
        content: const Text(
          'Notifications help you stay updated on startup activities, messages, and events. Please enable them in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToSignIn();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: const SignInScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F0230),
                Color(0xFF1A0A4A),
                Color(0xFF2D1070),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Glow blobs
              Positioned(
                top: -size.height * 0.15,
                right: -size.width * 0.25,
                child: _GlowBlob(
                  size: size.width * 0.8,
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                bottom: -size.height * 0.1,
                left: -size.width * 0.2,
                child: _GlowBlob(
                  size: size.width * 0.65,
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                ),
              ),

              // Particles
              ..._buildParticles(size),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // Globe with orbiting modes
                    SlideTransition(
                      position: _enterSlide,
                      child: FadeTransition(
                        opacity: _enterFade,
                        child: ScaleTransition(
                          scale: _enterScale,
                          child: _GlobeWithOrbit(
                            orbitController: _orbitController,
                            pulse: _pulse,
                            modes: _modes,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // App name
                    SlideTransition(
                      position: _enterSlide,
                      child: FadeTransition(
                        opacity: _enterFade,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Collab',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'ster',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFBBA7FF),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    SlideTransition(
                      position: _enterSlide,
                      child: FadeTransition(
                        opacity: _enterFade,
                        child: Text(
                          'Where founders, builders & collaborators connect.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Get Started button
                    SlideTransition(
                      position: _enterSlide,
                      child: FadeTransition(
                        opacity: _enterFade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _getStarted,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    const positions = [
      [0.08, 0.15], [0.92, 0.18], [0.05, 0.55], [0.95, 0.50],
      [0.20, 0.80], [0.75, 0.78], [0.50, 0.08], [0.65, 0.92],
    ];

    return positions.asMap().entries.map((entry) {
      final i = entry.key;
      final pos = entry.value;
      final delay = i * 0.3;
      final s = 3.0 + (i % 3) * 2.0;

      return Positioned(
        left: pos[0] * size.width,
        top: pos[1] * size.height,
        child: AnimatedBuilder(
          animation: _orbitController,
          builder: (_, __) {
            final t = (_orbitController.value + delay) % 1.0;
            final opacity = (math.sin(t * 2 * math.pi) * 0.5 + 0.5) * 0.45;
            return Opacity(
              opacity: opacity,
              child: Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.25),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ── Globe with Orbiting Modes ──────────────────────────────────────────────

class _GlobeWithOrbit extends StatelessWidget {
  const _GlobeWithOrbit({
    required this.orbitController,
    required this.pulse,
    required this.modes,
  });

  final AnimationController orbitController;
  final Animation<double> pulse;
  final List<(String, IconData, Color)> modes;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([orbitController, pulse]),
      builder: (_, __) {
        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse glow
              Transform.scale(
                scale: pulse.value,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C3AED).withValues(alpha: 0.25),
                        const Color(0xFF7C3AED).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Orbit ring
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                    width: 1.5,
                  ),
                ),
              ),

              // Second orbit ring (tilted)
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.5)
                  ..rotateZ(0.3),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // Orbiting mode labels
              for (var i = 0; i < modes.length; i++)
                Transform.rotate(
                  angle: orbitController.value * 2 * math.pi +
                      (i * 2 * math.pi / modes.length),
                  child: SizedBox(
                    width: 240,
                    height: 240,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _ModeLabel(
                        name: modes[i].$1,
                        icon: modes[i].$2,
                        color: modes[i].$3,
                      ),
                    ),
                  ),
                ),

              // Central globe
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B6FFF),
                      Color(0xFF7C3AED),
                      Color(0xFF5B21B6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.language_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Mode Label ─────────────────────────────────────────────────────────────

class _ModeLabel extends StatelessWidget {
  const _ModeLabel({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0, // counter-rotate so text stays upright
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Glow Blob ──────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

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
