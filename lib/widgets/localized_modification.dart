import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/design_model.dart';

class LocalizedModification extends StatefulWidget {
  final DesignModel currentDesign;
  final Function(DesignModel) onDesignChanged;
  final VoidCallback onSaveVersion;

  const LocalizedModification({
    super.key,
    required this.currentDesign,
    required this.onDesignChanged,
    required this.onSaveVersion,
  });

  @override
  State<LocalizedModification> createState() => _LocalizedModificationState();
}

class _LocalizedModificationState extends State<LocalizedModification> {
  String selectedPart = 'bodice';
  bool isInpaintMode = false;

  final List<Map<String, String>> dressParts = [
    {'id': 'bodice', 'label': 'Bodice', 'icon': '👗'},
    {'id': 'sleeves', 'label': 'Sleeves', 'icon': '👕'},
    {'id': 'skirt', 'label': 'Skirt', 'icon': '🎀'},
    {'id': 'neckline', 'label': 'Neckline', 'icon': '⭕'},
    {'id': 'waist', 'label': 'Waistline', 'icon': '➰'},
    {'id': 'hem', 'label': 'Hem', 'icon': '〰️'},
  ];

  final Map<String, List<Map<String, dynamic>>> attributes = {
    'bodice': [
      {
        'name': 'Pattern',
        'values': [
          'solid',
          'stripes',
          'polka-dots',
          'floral',
          'geometric',
          'lace',
        ],
      },
      {
        'name': 'Fit',
        'values': ['fitted', 'relaxed', 'loose', 'tailored'],
      },
      {
        'name': 'Detail',
        'values': ['buttons', 'ruching', 'pleats', 'draping', 'embroidery'],
      },
    ],
    'sleeves': [
      {
        'name': 'Length',
        'values': ['sleeveless', 'cap', 'short', 'three-quarter', 'long'],
      },
      {
        'name': 'Style',
        'values': ['puff', 'bell', 'fitted', 'bishop', 'flutter'],
      },
    ],
    // ... logic continues for other parts
  };

  void _addModification(String part, String attribute, String value) {
    final newMod = Modification(part: part, attribute: attribute, value: value);
    final updatedMods = [...widget.currentDesign.modifications, newMod];
    final newDesign = widget.currentDesign.copyWith(modifications: updatedMods);
    widget.onDesignChanged(newDesign);
  }

  @override
  Widget build(BuildContext context) {
    final currentAttrs = attributes[selectedPart] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildPartsGrid(),
          const SizedBox(height: 16),
          _buildAttributeCard(currentAttrs),
          const SizedBox(height: 12),
          if (widget.currentDesign.modifications.isNotEmpty)
            _buildActionButtons(),
          const SizedBox(height: 16),
          _buildSynthesisInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Granular Part Selection",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isInpaintMode ? Colors.purple : Colors.transparent,
            border: Border.all(
              color: isInpaintMode ? Colors.purple : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isInpaintMode ? 'Masked In-painting Active' : 'Standard Mode',
            style: TextStyle(
              fontSize: 10,
              color: isInpaintMode ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPartsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: dressParts.length,
      itemBuilder: (context, index) {
        final part = dressParts[index];
        final bool isSelected = selectedPart == part['id'];
        final bool isModified = widget.currentDesign.modifications.any(
          (mod) => mod.part == part['id'],
        );

        return GestureDetector(
          onTap: () => setState(() => selectedPart = part['id']!),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.purple : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(part['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  part['label']!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.purple : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isModified)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttributeCard(List<Map<String, dynamic>> currentAttrs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.sparkles, size: 14, color: Colors.purple),
              const SizedBox(width: 8),
              Text(
                "Modify: ${dressParts.firstWhere((p) => p['id'] == selectedPart)['label']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...currentAttrs.map((attr) => _buildDropdown(attr)),
          if (widget.currentDesign.modifications.isNotEmpty)
            _buildModificationList(),
        ],
      ),
    );
  }

  Widget _buildDropdown(Map<String, dynamic> attr) {
    final String attrName = attr['name'];
    final List<String> values = List<String>.from(attr['values']);

    // Find current value if exists in modifications
    final currentMod = widget.currentDesign.modifications.where(
      (m) => m.part == selectedPart && m.attribute == attrName,
    );
    final String? currentValue = currentMod.isNotEmpty
        ? currentMod.first.value
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attrName,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                hint: Text(
                  "Select ${attrName.toLowerCase()}",
                  style: const TextStyle(fontSize: 12),
                ),
                items: values
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(v, style: const TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    _addModification(selectedPart, attrName, val);
                    setState(() => isInpaintMode = true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onSaveVersion,
            icon: Icon(LucideIcons.check, size: 16),
            label: const Text("Save Version"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.outlined(
          onPressed: () {},
          icon: Icon(LucideIcons.undo2, size: 18),
        ),
      ],
    );
  }

  Widget _buildSynthesisInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🎯 Semantic Image Synthesis",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Modifications use masked in-painting to preserve spatial consistency. Only selected parts change.",
            style: TextStyle(fontSize: 10, color: Colors.amber.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildModificationList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Active Modifications (${widget.currentDesign.modifications.length})",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.currentDesign.modifications.map(
            (mod) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${mod.part}: ${mod.attribute} → ${mod.value}",
                  style: const TextStyle(fontSize: 10),
                ),
                Icon(LucideIcons.check, size: 12, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
