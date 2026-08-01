import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../auth/view/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;
  late final AnimationController _buttonController;
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;

  // ── Animations ─────────────────────────────────────────────────────────────
  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _orbit;
  late final Animation<double> _pulse;

  Timer? _bgTimer;
  Timer? _logoTimer;
  Timer? _textTimer;
  Timer? _taglineTimer;
  Timer? _buttonTimer;

  @override
  void initState() {
    super.initState();

    // Background fade
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bgFade = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    // Logo burst
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // App name
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade =
        CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Tagline
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineFade =
        CurvedAnimation(parent: _taglineController, curve: Curves.easeOut);
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOutCubic),
    );

    // CTA button
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _buttonFade =
        CurvedAnimation(parent: _buttonController, curve: Curves.easeOut);
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    // Continuous orbit ring
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _orbit = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_orbitController);

    // Pulse glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _runSequence();
  }

  void _runSequence() {
    _bgTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        _bgController.forward();
      }
    });

    _logoTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _logoController.forward();
      }
    });

    _textTimer = Timer(const Duration(milliseconds: 750), () {
      if (mounted) {
        _textController.forward();
      }
    });

    _taglineTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _taglineController.forward();
      }
    });

    _buttonTimer = Timer(const Duration(milliseconds: 1350), () {
      if (mounted) {
        _buttonController.forward();
      }
    });
  }

  void _getStarted() {
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
  void dispose() {
    _bgTimer?.cancel();
    _logoTimer?.cancel();
    _textTimer?.cancel();
    _taglineTimer?.cancel();
    _buttonTimer?.cancel();
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _buttonController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: _bgFade,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A0A4A),
                Color(0xFF2D1070),
                Color(0xFF4A1FA8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // ── Ambient glow blobs ──────────────────────────────────────
              Positioned(
                top: -size.height * 0.1,
                right: -size.width * 0.2,
                child: _GlowBlob(
                  size: size.width * 0.7,
                  color: const Color(0xFF6B4EFF).withValues(alpha: 0.25),
                ),
              ),
              Positioned(
                bottom: -size.height * 0.05,
                left: -size.width * 0.15,
                child: _GlowBlob(
                  size: size.width * 0.6,
                  color: const Color(0xFF2F80ED).withValues(alpha: 0.20),
                ),
              ),
              Positioned(
                top: size.height * 0.4,
                right: -size.width * 0.1,
                child: _GlowBlob(
                  size: size.width * 0.4,
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                ),
              ),

              // ── Floating particles ──────────────────────────────────────
              ..._buildParticles(size),

              // ── Content ─────────────────────────────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated logo
                            SlideTransition(
                              position: _logoSlide,
                              child: FadeTransition(
                                opacity: _logoFade,
                                child: ScaleTransition(
                                  scale: _logoScale,
                                  child: _AnimatedLogo(
                                    orbit: _orbit,
                                    pulse: _pulse,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // App name
                            SlideTransition(
                              position: _textSlide,
                              child: FadeTransition(
                                opacity: _textFade,
                                child: const _AppNameText(),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Tagline
                            SlideTransition(
                              position: _taglineSlide,
                              child: FadeTransition(
                                opacity: _taglineFade,
                                child: const _TaglineText(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // CTA
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                          child: SlideTransition(
                            position: _buttonSlide,
                            child: FadeTransition(
                              opacity: _buttonFade,
                              child: _GetStartedButton(onTap: _getStarted),
                            ),
                          ),
                        ),
                      ),
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

  List<Widget> _buildParticles(Size size) {
    const positions = [
      [0.12, 0.18],
      [0.85, 0.22],
      [0.05, 0.55],
      [0.92, 0.48],
      [0.25, 0.80],
      [0.70, 0.75],
      [0.48, 0.12],
      [0.60, 0.90],
    ];

    return positions.asMap().entries.map((entry) {
      final i = entry.key;
      final pos = entry.value;
      final delay = i * 0.3;
      final particleSize = 4.0 + (i % 3) * 3.0;

      return Positioned(
        left: pos[0] * size.width,
        top: pos[1] * size.height,
        child: AnimatedBuilder(
          animation: _orbitController,
          builder: (_, __) {
            final t = (_orbitController.value + delay) % 1.0;
            final opacity = (math.sin(t * 2 * math.pi) * 0.5 + 0.5) * 0.6;
            return Opacity(
              opacity: opacity,
              child: Container(
                width: particleSize,
                height: particleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 6,
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

// ── Animated Logo ────────────────────────────────────────────────────────────

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({required this.orbit, required this.pulse});

  final Animation<double> orbit;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([orbit, pulse]),
      builder: (_, __) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow pulse
              Transform.scale(
                scale: pulse.value,
                child: Container(
                  width: 176,
                  height: 176,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6B4EFF).withValues(alpha: 0.3),
                        const Color(0xFF6B4EFF).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Orbit ring
              Container(
                width: 158,
                height: 158,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              ),

              // Orbiting dot
              Transform.rotate(
                angle: orbit.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 158,
                      height: 158,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.8),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Second orbiting dot (offset by π)
              Transform.rotate(
                angle: orbit.value + math.pi,
                child: SizedBox(
                  width: 158,
                  height: 158,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2F80ED,
                            ).withValues(alpha: 0.8),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Central logo container
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B6FFF),
                      Color(0xFF6B4EFF),
                      Color(0xFF4A2FDD),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4EFF).withValues(alpha: 0.6),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: _LogoIcon(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom "C" nodes icon representing collaboration/network
class _LogoIcon extends StatelessWidget {
  const _LogoIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(painter: _CollabIconPainter()),
    );
  }
}

class _CollabIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 6.0;
    const outerR = 22.0;

    // Nodes at 5 positions (center + 4 outer)
    final nodes = [
      Offset(cx, cy), // center
      Offset(cx, cy - outerR), // top
      Offset(cx + outerR * math.cos(-math.pi / 6), cy + outerR * math.sin(-math.pi / 6)), // bottom-right
      Offset(cx - outerR * math.cos(-math.pi / 6), cy + outerR * math.sin(-math.pi / 6)), // bottom-left
      Offset(cx + outerR * 0.6, cy - outerR * 0.4), // right
      Offset(cx - outerR * 0.6, cy - outerR * 0.4), // left
    ];

    // Lines from center to outer nodes
    for (var i = 1; i < nodes.length; i++) {
      canvas.drawLine(nodes[0], nodes[i], linePaint);
    }
    // Line between outer nodes
    canvas.drawLine(nodes[1], nodes[4], linePaint);
    canvas.drawLine(nodes[1], nodes[5], linePaint);
    canvas.drawLine(nodes[2], nodes[3], linePaint);

    // Draw dots
    for (final node in nodes) {
      canvas.drawCircle(node, node == nodes[0] ? r : r * 0.75, paint);
    }
  }

  @override
  bool shouldRepaint(_CollabIconPainter oldDelegate) => false;
}

// ── App Name ─────────────────────────────────────────────────────────────────

class _AppNameText extends StatelessWidget {
  const _AppNameText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Collab',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: 'Sphere',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w300,
              color: Color(0xFFBBA7FF),
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tagline ───────────────────────────────────────────────────────────────────

class _TaglineText extends StatelessWidget {
  const _TaglineText();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Text(
        'Where founders, builders &\ncollaborators connect.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Color(0xFFAA99DD),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ── Get Started Button ────────────────────────────────────────────────────────

class _GetStartedButton extends StatefulWidget {
  const _GetStartedButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _hoverController.forward(),
        onTapUp: (_) {
          _hoverController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _hoverController.reverse(),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF8B6FFF), Color(0xFF6B4EFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4EFF).withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Glow Blob ─────────────────────────────────────────────────────────────────

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
