import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math' as math;

class PreferenceData {
  final List<({String color, int frequency})> favoriteColors;
  final List<({String fabric, int frequency})> favoriteFabrics;
  final List<({String style, int frequency})> favoriteStyles;
  final int totalDesigns;
  final double learningScore;

  PreferenceData({
    required this.favoriteColors,
    required this.favoriteFabrics,
    required this.favoriteStyles,
    required this.totalDesigns,
    required this.learningScore,
  });
}

class PreferenceLearning extends StatelessWidget {
  final PreferenceData data;

  const PreferenceLearning({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate max frequency for scaling progress bars
    final allFreqs = [
      ...data.favoriteColors.map((e) => e.frequency),
      ...data.favoriteFabrics.map((e) => e.frequency),
      ...data.favoriteStyles.map((e) => e.frequency),
      1,
    ];
    final int maxFrequency = allFreqs.reduce(math.max);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildLearningProgressCard(),
          const SizedBox(height: 16),
          _buildWeightsCard(maxFrequency),
          const SizedBox(height: 16),
          _buildInsightCard(),
          if (data.totalDesigns >= 5) ...[
            const SizedBox(height: 12),
            _buildAchievementCard(),
          ],
          const SizedBox(height: 16),
          _buildTechnicalNote(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(LucideIcons.brain, size: 20, color: Colors.purple.shade600),
        const SizedBox(width: 8),
        const Text(
          "AI Preference Learning",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLearningProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.pink.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.zap, size: 16, color: Colors.purple.shade700),
              const SizedBox(width: 4),
              Text(
                "Learning Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.purple.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${data.learningScore.toInt()}%",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.learningScore / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.5),
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Based on ${data.totalDesigns} designs",
            style: TextStyle(fontSize: 11, color: Colors.purple.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightsCard(int maxFrequency) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPreferenceSection(
              "Color Preferences",
              data.favoriteColors,
              maxFrequency,
              isColor: true,
            ),
            const Divider(height: 32),
            _buildPreferenceSection(
              "Fabric Preferences",
              data.favoriteFabrics,
              maxFrequency,
            ),
            const Divider(height: 32),
            _buildPreferenceSection(
              "Style Preferences",
              data.favoriteStyles,
              maxFrequency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection(
    String title,
    List<dynamic> items,
    int maxFreq, {
    bool isColor = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${items.length} tracked",
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.take(3).map((item) {
          final double progress = item.frequency / maxFreq;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                if (isColor)
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(item.color.replaceFirst('#', '0xFF')),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item is String
                                ? item
                                : item
                                      .toString()
                                      .split('(')
                                      .last
                                      .split(',')
                                      .first
                                      .split(':')
                                      .last
                                      .trim(), // Robust labeling
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            "${item.frequency}x",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade100,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(LucideIcons.trendingUp, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Personalized Insights",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.favoriteColors.isNotEmpty
                      ? "You prefer ${data.favoriteColors[0].color} tones. AI will prioritize complementary palettes."
                      : "Keep designing! AI will learn your preferences automatically.",
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade50, Colors.yellow.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.award, size: 32, color: Colors.amber),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Design Explorer",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78350F),
                ),
              ),
              Text(
                "Created ${data.totalDesigns}+ unique designs",
                style: TextStyle(fontSize: 11, color: Colors.amber.shade800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🤖 HITL Mechanism",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Human-in-the-Loop feedback continuously refines AI style weights for increasingly accurate recommendations.",
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
