import 'package:flutter/material.dart';

class DressPreview extends StatelessWidget {
  final String color;
  final String fabric;
  final String sleeve;
  final String neckline;
  final String pattern;
  final String length;

  const DressPreview({
    super.key,
    required this.color,
    required this.fabric,
    required this.sleeve,
    required this.neckline,
    required this.pattern,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    // Convert hex string to Flutter Color
    final baseColor = Color(int.parse(color.replaceFirst('#', '0xFF')));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade50, Colors.grey.shade200],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.8, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: CustomPaint(
                size: const Size(300, 500),
                painter: DressPainter(
                  color: baseColor,
                  fabric: fabric,
                  sleeve: sleeve,
                  neckline: neckline,
                  pattern: pattern,
                  length: length,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DressPainter extends CustomPainter {
  final Color color;
  final String fabric;
  final String sleeve;
  final String neckline;
  final String pattern;
  final String length;

  DressPainter({
    required this.color,
    required this.fabric,
    required this.sleeve,
    required this.neckline,
    required this.pattern,
    required this.length,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 50);
    final double dressHeight = length == 'mini'
        ? 200
        : length == 'midi'
        ? 280
        : 360;
    const double dressWidth = 160;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 1. Draw Main Body Path
    final bodyPath = Path()
      ..moveTo(center.dx - 50, center.dy - 20)
      ..lineTo(center.dx - 60, center.dy + 30)
      ..lineTo(center.dx - (dressWidth / 2), center.dy + dressHeight)
      ..lineTo(center.dx + (dressWidth / 2), center.dy + dressHeight)
      ..lineTo(center.dx + 60, center.dy + 30)
      ..lineTo(center.dx + 50, center.dy - 20)
      ..close();

    canvas.drawPath(bodyPath, paint);

    // 2. Draw Patterns (Programmatic Textures)
    _drawPattern(canvas, bodyPath, pattern);

    // 3. Draw Fabric Texture/Depth Overlay
    final double fabricOpacity = _getFabricOpacity(fabric);
    final depthGradient = LinearGradient(
      colors: [
        Colors.black.withValues(alpha: 0.1 * fabricOpacity),
        Colors.white.withValues(alpha: 0.1 * fabricOpacity),
        Colors.black.withValues(alpha: 0.1 * fabricOpacity),
      ],
    ).createShader(bodyPath.getBounds());

    canvas.drawPath(bodyPath, Paint()..shader = depthGradient);

    // 4. Neckline
    _drawNeckline(canvas, center, neckline, borderPaint);

    // 5. Sleeves
    _drawSleeves(canvas, center, sleeve, paint, borderPaint);

    // 6. Waist Detail
    final waistPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - 55, center.dy + 40),
      Offset(center.dx + 55, center.dy + 40),
      waistPaint,
    );

    // Final Outline
    canvas.drawPath(bodyPath, borderPaint);
  }

  void _drawPattern(Canvas canvas, Path clipPath, String type) {
    if (type == 'solid') return;

    canvas.save();
    canvas.clipPath(clipPath);
    final patternPaint = Paint()..color = Colors.white.withValues(alpha: 0.25);

    if (type == 'stripes') {
      for (double i = 0; i < 500; i += 20) {
        canvas.drawRect(Rect.fromLTWH(i, 0, 8, 1000), patternPaint);
      }
    } else if (type == 'polka-dots') {
      for (double i = 0; i < 500; i += 30) {
        for (double j = 0; j < 500; j += 30) {
          canvas.drawCircle(Offset(i, j), 4, patternPaint);
        }
      }
    }
    canvas.restore();
  }

  void _drawNeckline(Canvas canvas, Offset center, String type, Paint border) {
    if (type == 'v-neck') {
      final path = Path()
        ..moveTo(center.dx - 50, center.dy - 20)
        ..lineTo(center.dx, center.dy + 10)
        ..lineTo(center.dx + 50, center.dy - 20);
      canvas.drawPath(path, border);
    } else if (type == 'round') {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - 15),
          width: 110,
          height: 40,
        ),
        border,
      );
    }
    // ... Additional neckline logic
  }

  void _drawSleeves(
    Canvas canvas,
    Offset center,
    String type,
    Paint fill,
    Paint border,
  ) {
    if (type == 'short') {
      final leftSleeve = Path()
        ..moveTo(center.dx - 50, center.dy - 20)
        ..lineTo(center.dx - 75, center.dy - 10)
        ..lineTo(center.dx - 70, center.dy + 20)
        ..lineTo(center.dx - 60, center.dy + 30);
      canvas.drawPath(leftSleeve, fill);
      canvas.drawPath(leftSleeve, border);
      // Mirror for right side...
    }
    // ... Additional sleeve logic
  }

  double _getFabricOpacity(String fabric) {
    switch (fabric) {
      case 'silk':
        return 2.0;
      case 'velvet':
        return 3.0;
      default:
        return 1.0;
    }
  }

  @override
  bool shouldRepaint(covariant DressPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.pattern != pattern ||
      oldDelegate.length != length ||
      oldDelegate.sleeve != sleeve;
}
