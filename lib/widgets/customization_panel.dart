import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/design_model.dart';

class CustomizationPanel extends StatelessWidget {
  final DesignModel currentDesign;
  final Function(DesignModel) onDesignChanged;
  final VoidCallback onGenerateAI;
  final VoidCallback onRandomize;

  const CustomizationPanel({
    super.key,
    required this.currentDesign,
    required this.onDesignChanged,
    required this.onGenerateAI,
    required this.onRandomize,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> colors = [
      {'name': 'Crimson Red', 'value': '#DC143C'},
      {'name': 'Royal Blue', 'value': '#4169E1'},
      {'name': 'Emerald Green', 'value': '#50C878'},
      {'name': 'Sunset Orange', 'value': '#FF6347'},
      {'name': 'Lavender Purple', 'value': '#9370DB'},
      {'name': 'Rose Pink', 'value': '#FF69B4'},
      {'name': 'Midnight Black', 'value': '#1A1A1A'},
      {'name': 'Pearl White', 'value': '#F8F8FF'},
      {'name': 'Golden Yellow', 'value': '#FFD700'},
      {'name': 'Teal Blue', 'value': '#008080'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color Palette Section
          const Text(
            "Color Palette",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final c = colors[index];
              final bool isSelected = currentDesign.color == c['value'];
              final Color swatchColor = Color(
                int.parse(c['value']!.replaceFirst('#', '0xFF')),
              );

              return GestureDetector(
                onTap: () =>
                    onDesignChanged(currentDesign.copyWith(color: c['value']!)),
                child: Container(
                  decoration: BoxDecoration(
                    color: swatchColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Dropdown Selectors
          _buildDropdown(
            label: "Fabric Type",
            value: currentDesign.fabric,
            items: {
              'cotton': 'Cotton - Breathable',
              'silk': 'Silk - Luxurious',
              'velvet': 'Velvet - Rich',
              'linen': 'Linen - Light',
              'satin': 'Satin - Glossy',
            },
            onChanged: (value) =>
                onDesignChanged(currentDesign.copyWith(fabric: value)),
          ),

          _buildDropdown(
            label: "Sleeve Style",
            value: currentDesign.sleeve,
            items: {
              'sleeveless': 'Sleeveless - Modern',
              'cap': 'Cap Sleeve - Subtle',
              'short': 'Short Sleeve - Casual',
              'three-quarter': '3/4 Sleeve - Versatile',
              'long': 'Long Sleeve - Classic',
            },
            onChanged: (value) =>
                onDesignChanged(currentDesign.copyWith(sleeve: value)),
          ),

          _buildDropdown(
            label: "Neckline Design",
            value: currentDesign.neckline,
            items: {
              'round': 'Round Neck - Classic',
              'v-neck': 'V-Neck - Flattering',
              'boat': 'Boat Neck - Sophisticated',
              'sweetheart': 'Sweetheart - Romantic',
              'square': 'Square Neck - Modern',
            },
            onChanged: (value) =>
                onDesignChanged(currentDesign.copyWith(neckline: value)),
          ),

          _buildDropdown(
            label: "Pattern Style",
            value: currentDesign.pattern,
            items: {
              'solid': 'Solid - Clean',
              'stripes': 'Stripes - Bold',
              'polka-dots': 'Polka Dots - Playful',
              'floral': 'Floral - Delicate',
              'geometric': 'Geometric - Modern',
            },
            onChanged: (value) =>
                onDesignChanged(currentDesign.copyWith(pattern: value)),
          ),

          _buildDropdown(
            label: "Dress Length",
            value: currentDesign.length,
            items: {
              'mini': 'Mini - Above Knee',
              'midi': 'Midi - Below Knee',
              'maxi': 'Maxi - Full Length',
            },
            onChanged: (value) =>
                onDesignChanged(currentDesign.copyWith(length: value)),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.smart_toy, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gemini Assistant is ready to generate a fresh style using your current selections.',
                    style: TextStyle(color: Colors.blueGrey.shade800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          ElevatedButton.icon(
            onPressed: onGenerateAI,
            icon: Icon(LucideIcons.sparkles, size: 20),
            label: const Text("Gemini Generate Design"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRandomize,
            icon: Icon(LucideIcons.shuffle, size: 20),
            label: const Text("Randomize Style"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper to build consistent looking dropdowns
  Widget _buildDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: items.entries.map((e) {
              return DropdownMenuItem(value: e.key, child: Text(e.value));
            }).toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ],
      ),
    );
  }
}
