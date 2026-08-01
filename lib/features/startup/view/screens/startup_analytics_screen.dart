import 'package:flutter/material.dart';

class StartupAnalyticsScreen extends StatelessWidget {
  const StartupAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFF4338CA)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Analytics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PROFILE VIEWS', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('2,438', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34D399).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text('+10.4%', style: TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('vs last 30 days', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 16),
                        _ChartWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Top Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 14),
                  _MetricRow(icon: Icons.people_outline, label: 'Visitors', value: '2,438', change: '+13.2%', positive: true),
                  const SizedBox(height: 10),
                  _MetricRow(icon: Icons.person_add_outlined, label: 'Followers', value: '1,209', change: '+12.9%', positive: true),
                  const SizedBox(height: 10),
                  _MetricRow(icon: Icons.work_outline, label: 'Applications', value: '42', change: '+30.2%', positive: true),
                  const SizedBox(height: 10),
                  _MetricRow(icon: Icons.slideshow_outlined, label: 'Pitch Deck Views', value: '2,543', change: '-25.3%', positive: false),
                  const SizedBox(height: 24),
                  const Text('Traffic Sources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 14),
                  _sourceBar('Direct Search', 0.45, const Color(0xFF5B21B6)),
                  const SizedBox(height: 10),
                  _sourceBar('Social Media', 0.32, const Color(0xFF2563EB)),
                  const SizedBox(height: 10),
                  _sourceBar('Investor Referrals', 0.23, const Color(0xFF059669)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceBar(String label, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            Text('${(fraction * 100).round()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.icon, required this.label, required this.value, required this.change, required this.positive});
  final IconData icon;
  final String label, value, change;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF5B21B6), size: 22),
          ),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (positive ? const Color(0xFF059669) : const Color(0xFFDC2626)).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              change,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: positive ? const Color(0xFF059669) : const Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const points = [40.0, 55.0, 45.0, 65.0, 50.0, 75.0, 60.0, 80.0, 70.0, 90.0];
    return SizedBox(
      height: 60,
      child: CustomPaint(
        painter: _LineChartPainter(points: points),
        size: const Size(double.infinity, 60),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});
  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final min = points.reduce((a, b) => a < b ? a : b);
    final max = points.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height - ((points[i] - min) / (max - min)) * size.height * 0.8 - size.height * 0.1;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) => false;
}
