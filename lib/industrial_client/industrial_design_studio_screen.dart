import 'package:flutter/material.dart';
import 'industrial_preview.dart';

class IndustrialDesignStudioScreen extends StatefulWidget {
  final String designName;
  final String dressType;
  final String fabric;
  final String color;
  final String pattern;
  final String season;
  final String bust;
  final String waist;
  final String hip;
  final String length;
  final String sleeve;
  final String description;

  const IndustrialDesignStudioScreen({
    super.key,
    required this.designName,
    required this.dressType,
    required this.fabric,
    required this.color,
    required this.pattern,
    required this.season,
    required this.bust,
    required this.waist,
    required this.hip,
    required this.length,
    required this.sleeve,
    required this.description,
  });

  @override
  State<IndustrialDesignStudioScreen> createState() =>
      _IndustrialDesignStudioScreenState();
}

class _IndustrialDesignStudioScreenState
    extends State<IndustrialDesignStudioScreen> {
  // Design modification controllers
  late TextEditingController necklineController;
  late TextEditingController fitController;
  late TextEditingController embellishmentController;

  // Color accent selection
  String selectedAccentColor = 'Gold';
  String selectedNeckline = 'Round';
  String selectedFit = 'Fitted';
  int _selectedPrimaryColorIndex = 0;
  int _selectedSecondaryColorIndex = 1;

  // Color swatches for color coaching
  final List<Color> _colorSwatches = [
    const Color(0xFF16192E),
    const Color(0xFF1E293B),
    const Color(0xFF0F4C81),
    const Color(0xFF583D8A),
    const Color(0xFFE04A66),
    const Color(0xFFF9690E),
    const Color(0xFFF9A825),
    const Color(0xFFE6E29B),
    const Color(0xFFFFFFFF),
    const Color(0xFF334155),
    const Color(0xFFEF5350),
    const Color(0xFFED7E43),
    const Color(0xFFFDD835),
    const Color(0xFF2ECC71),
    const Color(0xFF6A1B9A),
  ];

  // Theme colors
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color titleColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color textColor = const Color(0xFF2D3748);
  final Color cardBackgroundColor = Colors.white;
  final Color primaryButtonColor = const Color(0xFF111827);
  final Color borderColor = const Color(0xFFE5E9F0);
  final Color accentColor = const Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    necklineController = TextEditingController();
    fitController = TextEditingController();
    embellishmentController = TextEditingController();
  }

  @override
  void dispose() {
    necklineController.dispose();
    fitController.dispose();
    embellishmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Back Button & Header ---
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back, color: titleColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Industrial Design Studio',
                              style: TextStyle(
                                fontSize: isLargeScreen ? 28 : 24,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.designName,
                              style: TextStyle(
                                fontSize: isLargeScreen ? 15 : 14,
                                fontWeight: FontWeight.w500,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // --- Adaptive Layout ---
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: _buildDesignCanvas()),
                            const SizedBox(width: 32),
                            Expanded(flex: 5, child: _buildDesignControls()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildDesignCanvas(),
                            const SizedBox(height: 32),
                            _buildDesignControls(),
                          ],
                        ),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignCanvas() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade50, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checkroom,
                    size: 80,
                    color: accentColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Design Render Area',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.dressType} - ${widget.color}',
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDesignDetails(),
        ],
      ),
    );
  }

  Widget _buildDesignDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Design Specifications',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Dress Type:', widget.dressType),
        _buildDetailRow('Fabric:', widget.fabric),
        _buildDetailRow('Color:', widget.color),
        _buildDetailRow('Pattern:', widget.pattern),
        _buildDetailRow('Season:', widget.season),
        const SizedBox(height: 12),
        Text(
          'Measurements',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Bust:', '${widget.bust} cm'),
        _buildDetailRow('Waist:', '${widget.waist} cm'),
        _buildDetailRow('Hip:', '${widget.hip} cm'),
        _buildDetailRow('Length:', '${widget.length} cm'),
        _buildDetailRow('Sleeve:', '${widget.sleeve} cm'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: subtitleColor)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Modifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),
          // --- Color Coaching Section ---
          Text(
            'Primary Color',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildColorSelectionGrid(
            _selectedPrimaryColorIndex,
            (idx) => setState(() => _selectedPrimaryColorIndex = idx),
          ),
          const SizedBox(height: 24),
          Text(
            'Accent Color (Secondary)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildColorSelectionGrid(
            _selectedSecondaryColorIndex,
            (idx) => setState(() => _selectedSecondaryColorIndex = idx),
          ),
          const SizedBox(height: 24),
          // --- Style & Fit Section ---
          Text(
            'Style & Fit',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildControlDropdown(
            'Neckline',
            selectedNeckline,
            ['Round', 'V-Neck', 'Square', 'Boat', 'Sweetheart', 'Off-Shoulder'],
            (value) {
              setState(() => selectedNeckline = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildControlDropdown(
            'Fit Style',
            selectedFit,
            ['Fitted', 'Regular', 'Loose', 'Oversized', 'A-Line', 'Flared'],
            (value) {
              setState(() => selectedFit = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildControlDropdown(
            'Accent Color',
            selectedAccentColor,
            ['Gold', 'Silver', 'Copper', 'Bronze', 'Pearl', 'None'],
            (value) {
              setState(() => selectedAccentColor = value!);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Additional Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: embellishmentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add embellishments, pockets, buttons, etc.',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: titleColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: accentColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Modifications will be reflected in the design preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelectionGrid(
    int selectedIndex,
    Function(int) onColorSelected,
  ) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: List.generate(_colorSwatches.length, (index) {
        final Color swatchColor = _colorSwatches[index];
        final bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onColorSelected(index),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: swatchColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? titleColor : Colors.transparent,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : const SizedBox.shrink(),
          ),
        );
      }),
    );
  }

  Widget _buildControlDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: titleColor),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: titleColor),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Input',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryButtonColor, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryButtonColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _proceedToPreview,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.preview, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Preview Design',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _proceedToPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndustrialPreviewScreen(
          designName: widget.designName,
          dressType: widget.dressType,
          fabric: widget.fabric,
          color: widget.color,
          pattern: widget.pattern,
          neckline: selectedNeckline,
          fit: selectedFit,
          accentColor: selectedAccentColor,
          embellishments: embellishmentController.text,
          primaryColor: _colorSwatches[_selectedPrimaryColorIndex],
          secondaryColor: _colorSwatches[_selectedSecondaryColorIndex],
        ),
      ),
    );
  }
}
