import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Measurements {
  double bust;
  double waist;
  double hips;
  double height;

  Measurements({
    required this.bust,
    required this.waist,
    required this.hips,
    required this.height,
  });
}

class BiometricInput extends StatelessWidget {
  final String skinToneHex;
  final String bodyType;
  final Measurements measurements;
  final Function(String) onSkinToneChange;
  final Function(String) onBodyTypeChange;
  final Function(String, double) onMeasurementChange;
  final VoidCallback onScanFace;

  const BiometricInput({
    super.key,
    required this.skinToneHex,
    required this.bodyType,
    required this.measurements,
    required this.onSkinToneChange,
    required this.onBodyTypeChange,
    required this.onMeasurementChange,
    required this.onScanFace,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> skinTones = [
      {'name': 'Fair', 'value': '#FFE4C4', 'temp': 'Cool'},
      {'name': 'Light', 'value': '#F5D7B1', 'temp': 'Neutral'},
      {'name': 'Medium', 'value': '#D4A574', 'temp': 'Warm'},
      {'name': 'Tan', 'value': '#C89F6F', 'temp': 'Warm'},
      {'name': 'Deep', 'value': '#8B6F47', 'temp': 'Rich'},
      {'name': 'Dark', 'value': '#654321', 'temp': 'Deep'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3D Face Scanning Card
          _buildActionCard(
            title: "3D Face Scanning",
            subtitle: "Personalized color analysis",
            icon: LucideIcons.camera,
            buttonText: "Scan Face for Analysis",
            onPressed: onScanFace,
            color: Colors.purple,
          ),
          const SizedBox(height: 24),

          // Skin Tone Selection
          const Text(
            "Skin Tone & Undertone",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: skinTones.map((tone) => _buildToneButton(tone)).toList(),
          ),
          const SizedBox(height: 24),

          // Body Type Selection
          _buildLabel(LucideIcons.user, "Body Type Classification"),
          DropdownButtonFormField<String>(
            initialValue: bodyType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(
                value: "hourglass",
                child: Text("Hourglass - Balanced"),
              ),
              DropdownMenuItem(
                value: "pear",
                child: Text("Pear - Lower emphasis"),
              ),
              DropdownMenuItem(
                value: "apple",
                child: Text("Apple - Upper emphasis"),
              ),
              DropdownMenuItem(
                value: "rectangle",
                child: Text("Rectangle - Uniform"),
              ),
            ],
            onChanged: (val) => onBodyTypeChange(val!),
          ),
          const SizedBox(height: 24),

          // Ergonomic Measurements
          _buildLabel(LucideIcons.ruler, "Ergonomic Measurements (inches)"),
          _buildMeasurementSlider("Bust", measurements.bust, 28, 50, 'bust'),
          _buildMeasurementSlider("Waist", measurements.waist, 22, 44, 'waist'),
          _buildMeasurementSlider("Hips", measurements.hips, 30, 52, 'hips'),
          _buildMeasurementSlider(
            "Height",
            measurements.height,
            54,
            78,
            'height',
          ),
          const SizedBox(height: 24),

          // AI Fit Analysis Card
          _buildFitAnalysisCard(),
        ],
      ),
    );
  }

  // UI Helpers
  Widget _buildLabel(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            Colors.pink.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(LucideIcons.camera, size: 16),
            label: Text(buttonText),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToneButton(Map<String, String> tone) {
    final bool isSelected = skinToneHex == tone['value'];
    final Color toneColor = Color(
      int.parse(tone['value']!.replaceFirst('#', '0xFF')),
    );

    return GestureDetector(
      onTap: () => onSkinToneChange(tone['value']!),
      child: Container(
        decoration: BoxDecoration(
          color: toneColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(9),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    tone['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tone['temp']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSlider(
    String label,
    double value,
    double min,
    double max,
    String key,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "${value.toStringAsFixed(1)}\"",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: (val) => onMeasurementChange(key, val),
          activeColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildFitAnalysisCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI Fit Analysis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "• Recommended: ${bodyType == 'hourglass' ? 'Fitted waist designs' : 'A-line silhouettes'}",
            style: TextStyle(color: Colors.blue.shade700, fontSize: 11),
          ),
          Text(
            "• Optimal comfort: ${measurements.waist < 28 ? 'Tailored fit' : 'Regular fit'}",
            style: TextStyle(color: Colors.blue.shade700, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
