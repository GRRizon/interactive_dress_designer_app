import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Add lucide_icons to pubspec.yaml
import '../models/design_model.dart';

// Data model for the current design state
class AISuggestions extends StatelessWidget {
  final DesignModel currentDesign;

  const AISuggestions({super.key, required this.currentDesign});

  String _getSeasonRecommendation() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return "Spring";
    if (month >= 6 && month <= 8) return "Summer";
    if (month >= 9 && month <= 11) return "Fall";
    return "Winter";
  }

  @override
  Widget build(BuildContext context) {
    // Generate suggestions based on logic
    final suggestions = [
      {
        "icon": LucideIcons.trendingUp,
        "title": "Trending Style",
        "description":
            "${currentDesign.length[0].toUpperCase()}${currentDesign.length.substring(1)} dresses are trending this season!",
        "type": "trend",
        "color": Colors.purple,
      },
      {
        "icon": LucideIcons.award,
        "title": "Perfect Match",
        "description":
            "${currentDesign.fabric[0].toUpperCase()}${currentDesign.fabric.substring(1)} fabric pairs beautifully with ${currentDesign.pattern} patterns.",
        "type": "match",
        "color": Colors.blue,
      },
      {
        "icon": LucideIcons.lightbulb,
        "title": "Designer Tip",
        "description": _getNecklineTip(currentDesign.neckline),
        "type": "tip",
        "color": Colors.green,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "AI Insights",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${_getSeasonRecommendation()} 2026",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Animated Suggestion Cards
        ...suggestions.asMap().entries.map((entry) {
          int index = entry.key;
          var suggestion = entry.value;

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(-(20 * (1 - value)), 0),
                  child: child,
                ),
              );
            },
            child: _buildSuggestionCard(suggestion),
          );
        }),

        const SizedBox(height: 16),

        // Confidence Score Card
        _buildConfidenceCard(),
      ],
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.05),
            Colors.blue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data['icon'], color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['description'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard() {
    final score = 85 + Random().nextInt(10);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade50, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          const Text("✨", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          const Text(
            "AI Confidence Score",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            "$score%",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "This design is well-balanced and fashion-forward",
            style: TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getNecklineTip(String neckline) {
    switch (neckline.toLowerCase()) {
      case 'v-neck':
        return "V-neck creates an elongating effect, perfect for formal occasions.";
      case 'sweetheart':
        return "Sweetheart necklines add romantic elegance to any dress.";
      case 'boat':
        return "Boat necklines provide sophisticated, timeless appeal.";
      default:
        return "Round necklines are classic and universally flattering.";
    }
  }
}
