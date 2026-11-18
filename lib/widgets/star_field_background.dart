import 'dart:math';
import 'package:flutter/material.dart';

class StarFieldBackground extends StatefulWidget {
  final Widget child;
  const StarFieldBackground({super.key, required this.child});

  @override
  State<StarFieldBackground> createState() => _StarFieldBackgroundState();
}

class _StarFieldBackgroundState extends State<StarFieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final Random _random = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    for (int i = 0; i < 120; i++) {
      _stars.add(_Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.2 + 0.6,
        alphaSpeed: _random.nextDouble() * 2 + 0.5,
        baseAlpha: _random.nextDouble() * 0.5 + 0.3,
        color: _getRandomStarColor(_random),
      ));
    }
  }

  Color _getRandomStarColor(Random r) {
    final colors = [
      Colors.white,
      const Color(0xFFE0F7FA),
      const Color(0xFFFFF9C4),
      const Color(0xFFE1BEE7),
      const Color(0xFF80DEEA),
    ];
    return colors[r.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep space gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.4,
              colors: [
                Color(0xFF0F1538),
                Color(0xFF070B1E),
                Color(0xFF03040C),
              ],
            ),
          ),
        ),
        // Twinkling Star Field
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _StarFieldPainter(_stars, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Glow effect
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.08),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.06),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double alphaSpeed;
  final double baseAlpha;
  final Color color;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.alphaSpeed,
    required this.baseAlpha,
    required this.color,
  });
}

class _StarFieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarFieldPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final double sinVal = sin((progress * pi * 2 * star.alphaSpeed));
      final double alpha = (star.baseAlpha + sinVal * 0.3).clamp(0.1, 1.0);
      final paint = Paint()
        ..color = star.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      final dx = star.x * size.width;
      final dy = star.y * size.height;

      canvas.drawCircle(Offset(dx, dy), star.size, paint);

      if (star.size > 2.0) {
        final glowPaint = Paint()
          ..color = star.color.withValues(alpha: alpha * 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(dx, dy), star.size * 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => true;
}
