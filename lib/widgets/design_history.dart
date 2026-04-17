import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models/design_version.dart';

class DesignHistory extends StatelessWidget {
  final List<DesignVersion> versions;
  final Function(DesignVersion) onVersionSelected;

  const DesignHistory({
    super.key,
    required this.versions,
    required this.onVersionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (versions.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Design History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF374151), // gray-700
              ),
            ),
            Text(
              "${versions.length} versions",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(right: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Adjust for card height
            ),
            itemCount: versions.length,
            itemBuilder: (context, index) {
              final version = versions[index];
              return _buildVersionCard(version, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVersionCard(DesignVersion version, int index) {
    final Color backgroundColor = Color(
      int.parse(version.config.color.replaceFirst('#', '0xFF')),
    );

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => onVersionSelected(version),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SVG-like Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(45, 60),
                      painter: DressIconPainter(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Details
              Text(
                "${version.config.fabric[0].toUpperCase()}${version.config.fabric.substring(1)} ${version.config.pattern != 'solid' ? '• ${version.config.pattern}' : ''}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "${version.config.sleeve} • ${version.config.neckline}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('hh:mm a').format(version.timestamp),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.clock,
            size: 48,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            "No design history yet",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const Text(
            "Your AI-generated designs will appear here",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to replicate the SVG path
class DressIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    // Replicating the SVG Path: M 20,10 L 18,20 L 12,60 L 48,60 L 42,20 L 40,10 Z
    // Scaled to fit the widget size
    path.moveTo(size.width * 0.33, size.height * 0.125); // 20,10
    path.lineTo(size.width * 0.3, size.height * 0.25); // 18,20
    path.lineTo(size.width * 0.2, size.height * 0.75); // 12,60
    path.lineTo(size.width * 0.8, size.height * 0.75); // 48,60
    path.lineTo(size.width * 0.7, size.height * 0.25); // 42,20
    path.lineTo(size.width * 0.66, size.height * 0.125); // 40,10
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
