import 'package:flutter/material.dart';
import 'industrial_design_studio_screen.dart';

class IndustrialInputScreen extends StatefulWidget {
  const IndustrialInputScreen({super.key});

  @override
  State<IndustrialInputScreen> createState() => _IndustrialInputScreenState();
}

class _IndustrialInputScreenState extends State<IndustrialInputScreen> {
  // Form Controllers
  late TextEditingController designNameController;
  late TextEditingController bustController;
  late TextEditingController waistController;
  late TextEditingController hipController;
  late TextEditingController lengthController;
  late TextEditingController sleeveController;
  late TextEditingController descriptionController;

  // Dropdown selections
  String selectedDressType = 'Casual Dress';
  String selectedFabric = 'Cotton';
  String selectedColor = 'Black';
  String selectedPattern = 'Solid';
  String selectedSeason = 'All Season';

  // Theme colors
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color titleColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color textColor = const Color(0xFF2D3748);
  final Color cardBackgroundColor = Colors.white;
  final Color primaryButtonColor = const Color(0xFF111827);
  final Color borderColor = const Color(0xFFE5E9F0);

  @override
  void initState() {
    super.initState();
    designNameController = TextEditingController();
    bustController = TextEditingController();
    waistController = TextEditingController();
    hipController = TextEditingController();
    lengthController = TextEditingController();
    sleeveController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    designNameController.dispose();
    bustController.dispose();
    waistController.dispose();
    hipController.dispose();
    lengthController.dispose();
    sleeveController.dispose();
    descriptionController.dispose();
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
                  // --- Header Section ---
                  Text(
                    'Industrial Design Input',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter industrial-level specifications for precise dress design manufacturing',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 15 : 14,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // --- Adaptive Layout ---
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: _buildInputForm()),
                            const SizedBox(width: 32),
                            Expanded(flex: 5, child: _buildPreviewCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildInputForm(),
                            const SizedBox(height: 32),
                            _buildPreviewCard(),
                          ],
                        ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Specifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Design Name',
            designNameController,
            'Enter design name',
            Icons.design_services,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Dress Type',
            selectedDressType,
            [
              'Casual Dress',
              'Formal Dress',
              'Saree',
              'Kurti',
              'Gown',
              'Suit',
              'Lehenga',
            ],
            (value) {
              setState(() => selectedDressType = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Fabric Type',
            selectedFabric,
            [
              'Cotton',
              'Silk',
              'Linen',
              'Wool',
              'Polyester',
              'Blend',
              'Chiffon',
            ],
            (value) {
              setState(() => selectedFabric = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Primary Color',
            selectedColor,
            [
              'Black',
              'White',
              'Red',
              'Blue',
              'Green',
              'Yellow',
              'Purple',
              'Pink',
              'Brown',
            ],
            (value) {
              setState(() => selectedColor = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Pattern',
            selectedPattern,
            ['Solid', 'Striped', 'Floral', 'Checkered', 'Geometric', 'Printed'],
            (value) {
              setState(() => selectedPattern = value!);
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Season',
            selectedSeason,
            ['Summer', 'Winter', 'Spring', 'Fall', 'All Season'],
            (value) {
              setState(() => selectedSeason = value!);
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Measurements (in cm)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Bust',
                  bustController,
                  'e.g., 90',
                  Icons.straighten,
                  isNumeric: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Waist',
                  waistController,
                  'e.g., 75',
                  Icons.straighten,
                  isNumeric: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Hip',
                  hipController,
                  'e.g., 100',
                  Icons.straighten,
                  isNumeric: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Length',
                  lengthController,
                  'e.g., 100',
                  Icons.straighten,
                  isNumeric: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Sleeve Length',
            sleeveController,
            'e.g., 60',
            Icons.straighten,
            isNumeric: true,
          ),
          const SizedBox(height: 20),
          Text(
            'Additional Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Add any special requirements, embellishments, or design details...',
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
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool isNumeric = false,
  }) {
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
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: subtitleColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
      ],
    );
  }

  Widget _buildDropdownField(
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

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.preview, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Design Preview',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSpecificationSummary(),
        ],
      ),
    );
  }

  Widget _buildSpecificationSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications Summary',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildSummaryItem('Dress Type:', selectedDressType),
        _buildSummaryItem('Fabric:', selectedFabric),
        _buildSummaryItem('Color:', selectedColor),
        _buildSummaryItem('Pattern:', selectedPattern),
        _buildSummaryItem('Season:', selectedSeason),
        if (bustController.text.isNotEmpty)
          _buildSummaryItem(
            'Measurements:',
            '${bustController.text}-${waistController.text}-${hipController.text}',
          ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
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
            onTap: _validateAndSubmit,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_forward, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Proceed to Design Studio',
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }

  void _validateAndSubmit() {
    if (designNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a design name')),
      );
      return;
    }

    if (bustController.text.isEmpty ||
        waistController.text.isEmpty ||
        hipController.text.isEmpty ||
        lengthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all measurements')),
      );
      return;
    }

    // Pass data to design studio
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndustrialDesignStudioScreen(
          designName: designNameController.text,
          dressType: selectedDressType,
          fabric: selectedFabric,
          color: selectedColor,
          pattern: selectedPattern,
          season: selectedSeason,
          bust: bustController.text,
          waist: waistController.text,
          hip: hipController.text,
          length: lengthController.text,
          sleeve: sleeveController.text,
          description: descriptionController.text,
        ),
      ),
    );
  }
}
