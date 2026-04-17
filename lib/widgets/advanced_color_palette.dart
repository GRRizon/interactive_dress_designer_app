import 'package:flutter/material.dart';

class ColorData {
  final String name;
  final Color color;
  final String hex;

  ColorData({required this.name, required this.color, required this.hex});
}

class AdvancedColorPalette extends StatefulWidget {
  final String selectedColorHex;
  final Function(String) onColorChange;
  final String? skinToneHex;

  const AdvancedColorPalette({
    super.key,
    required this.selectedColorHex,
    required this.onColorChange,
    this.skinToneHex,
  });

  @override
  State<AdvancedColorPalette> createState() => _AdvancedColorPaletteState();
}

class _AdvancedColorPaletteState extends State<AdvancedColorPalette> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";

  // Comprehensive color categories mapped to Flutter Colors
  final Map<String, List<ColorData>> _colorCategories = {
    'Reds': [
      ColorData(
        name: 'Crimson',
        hex: '#DC143C',
        color: const Color(0xFFDC143C),
      ),
      ColorData(
        name: 'Scarlet',
        hex: '#FF2400',
        color: const Color(0xFFFF2400),
      ),
      ColorData(name: 'Ruby', hex: '#E0115F', color: const Color(0xFFE0115F)),
      ColorData(name: 'Cherry', hex: '#DE3163', color: const Color(0xFFDE3163)),
      ColorData(
        name: 'Burgundy',
        hex: '#800020',
        color: const Color(0xFF800020),
      ),
      ColorData(name: 'Coral', hex: '#FF7F50', color: const Color(0xFFFF7F50)),
    ],
    'Blues': [
      ColorData(name: 'Navy', hex: '#000080', color: const Color(0xFF000080)),
      ColorData(name: 'Royal', hex: '#4169E1', color: const Color(0xFF4169E1)),
      ColorData(name: 'Azure', hex: '#007FFF', color: const Color(0xFF007FFF)),
      ColorData(name: 'Teal', hex: '#008080', color: const Color(0xFF008080)),
      ColorData(name: 'Steel', hex: '#4682B4', color: const Color(0xFF4682B4)),
    ],
    'Greens': [
      ColorData(
        name: 'Emerald',
        hex: '#50C878',
        color: const Color(0xFF50C878),
      ),
      ColorData(name: 'Forest', hex: '#228B22', color: const Color(0xFF228B22)),
      ColorData(name: 'Mint', hex: '#98FF98', color: const Color(0xFF98FF98)),
      ColorData(name: 'Olive', hex: '#808000', color: const Color(0xFF808000)),
    ],
    // ... Add more from your React list following this pattern
  };

  // AI Recommendation Logic
  List<String> getRecommendedColors() {
    if (widget.skinToneHex == null) return [];

    // Simple brightness calculation logic
    final String hex = widget.skinToneHex!.replaceFirst('#', '');
    final int skinValue = int.parse(hex, radix: 16);
    final int r = (skinValue >> 16) & 0xFF;
    final int g = (skinValue >> 8) & 0xFF;
    final int b = skinValue & 0xFF;
    final int brightness = r + g + b;

    if (brightness > 600) {
      return ['#DC143C', '#000080', '#50C878', '#8F00FF', '#FFD700'];
    } else if (brightness > 400) {
      return ['#FF6347', '#008080', '#9DC183', '#C68E17', '#E0115F'];
    } else {
      return ['#4169E1', '#50C878', '#FFD700', '#FF00FF', '#FF7F50'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommended = getRecommendedColors();
    final categories = _colorCategories.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Row(
          children: [
            Icon(Icons.palette, size: 18, color: Colors.purple),
            SizedBox(width: 8),
            Text(
              "500+ Chromatic Palette",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search Bar
        TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchTerm = val),
          decoration: InputDecoration(
            hintText: "Search colors...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
        const SizedBox(height: 16),

        // AI Recommendations Section
        if (recommended.isNotEmpty && _searchTerm.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade100),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AI Color Matching",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    Chip(
                      label: Text(
                        "Personalized",
                        style: TextStyle(fontSize: 10),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: recommended
                      .map((hex) => _buildColorButton(hex, isAI: true))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Tabbed Color Grid
        DefaultTabController(
          length: categories.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.grey,
                tabs: categories.map((name) => Tab(text: name)).toList(),
              ),
              SizedBox(
                height: 250,
                child: TabBarView(
                  children: categories.map((cat) {
                    final filtered = _colorCategories[cat]!
                        .where(
                          (c) =>
                              c.name.toLowerCase().contains(
                                _searchTerm.toLowerCase(),
                              ) ||
                              c.hex.toLowerCase().contains(
                                _searchTerm.toLowerCase(),
                              ),
                        )
                        .toList();

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _buildColorButton(filtered[index].hex),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Current Selection Footer
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(
                      widget.selectedColorHex.replaceFirst('#', '0xFF'),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Color",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    widget.selectedColorHex,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to build color circles/squares
  Widget _buildColorButton(String hex, {bool isAI = false}) {
    final isSelected = widget.selectedColorHex == hex;
    final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () => widget.onColorChange(hex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        width: isAI ? 45 : null,
        height: isAI ? 45 : null,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black26, blurRadius: 4)]
              : null,
        ),
      ),
    );
  }
}
