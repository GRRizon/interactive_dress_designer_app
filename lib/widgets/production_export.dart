import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExportOptions {
  bool includeTechPack;
  bool includeMeasurements;
  bool includePatternFiles;
  bool includeFabricSpecs;
  String fileFormat;

  ExportOptions({
    this.includeTechPack = true,
    this.includeMeasurements = true,
    this.includePatternFiles = false,
    this.includeFabricSpecs = true,
    this.fileFormat = 'pdf',
  });
}

class ProductionExport extends StatefulWidget {
  final Map<String, dynamic> design;
  final Map<String, double> measurements;
  final Function(String, ExportOptions) onExport;
  final VoidCallback onPlaceOrder;

  const ProductionExport({
    super.key,
    required this.design,
    required this.measurements,
    required this.onExport,
    required this.onPlaceOrder,
  });

  @override
  State<ProductionExport> createState() => _ProductionExportState();
}

class _ProductionExportState extends State<ProductionExport>
    with SingleTickerProviderStateMixin {
  late ExportOptions options;
  bool isExporting = false;
  bool exportComplete = false;

  @override
  void initState() {
    super.initState();
    options = ExportOptions();
  }

  Future<void> _handleExport() async {
    setState(() => isExporting = true);

    // Simulate generation delay
    await Future.delayed(const Duration(seconds: 2));

    widget.onExport(options.fileFormat, options);

    setState(() {
      isExporting = false;
      exportComplete = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => exportComplete = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildDesignSummary(),
          const SizedBox(height: 12),
          _buildMeasurementSummary(),
          const SizedBox(height: 20),
          _buildFormatSelector(),
          const SizedBox(height: 20),
          _buildOptionsChecklist(),
          const SizedBox(height: 24),
          _buildExportButton(),
          const SizedBox(height: 16),
          _buildOrderCard(),
          const SizedBox(height: 16),
          _buildSustainabilityNote(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(LucideIcons.package, color: Colors.purple.shade600, size: 20),
        const SizedBox(width: 8),
        const Text(
          "Production-Ready Export",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDesignSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DESIGN SPECIFICATION",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            children: widget.design.entries
                .map((e) => _buildSpecItem(e.key, e.value))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, dynamic value) {
    return Row(
      children: [
        Text(
          "${label[0].toUpperCase()}${label.substring(1)}: ",
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
        if (label == 'color') ...[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(
                int.parse(value.toString().replaceFirst('#', '0xFF')),
              ),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMeasurementSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.ruler, size: 14, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text(
                "Body Measurements",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.measurements.entries
                .map(
                  (e) => Column(
                    children: [
                      Text(
                        e.key.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        "${e.value}\"",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "File Format",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: options.fileFormat,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: const [
            DropdownMenuItem(
              value: 'pdf',
              child: _FormatItem(
                title: "PDF Document",
                sub: "Printable tech pack",
              ),
            ),
            DropdownMenuItem(
              value: 'dxf',
              child: _FormatItem(title: "DXF Pattern", sub: "CAD format"),
            ),
          ],
          onChanged: (val) => setState(() => options.fileFormat = val!),
        ),
      ],
    );
  }

  Widget _buildOptionsChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Include in Export",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        _buildCheckTile(
          "Technical Pack",
          "Construction details",
          options.includeTechPack,
          (v) => setState(() => options.includeTechPack = v!),
        ),
        _buildCheckTile(
          "Body Measurements",
          "Size specs",
          options.includeMeasurements,
          (v) => setState(() => options.includeMeasurements = v!),
        ),
        _buildCheckTile(
          "Pattern Files",
          "Cutting templates",
          options.includePatternFiles,
          (v) => setState(() => options.includePatternFiles = v!),
        ),
      ],
    );
  }

  Widget _buildCheckTile(
    String title,
    String sub,
    bool val,
    Function(bool?) onToggle,
  ) {
    return CheckboxListTile(
      value: val,
      onChanged: onToggle,
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (isExporting || exportComplete) ? null : _handleExport,
        style: ElevatedButton.styleFrom(
          backgroundColor: exportComplete ? Colors.green : Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExporting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text("Generating Files..."),
                  ],
                )
              : exportComplete
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.checkCircle2),
                    const SizedBox(width: 8),
                    const Text("Export Complete!"),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.download),
                    const SizedBox(width: 8),
                    const Text("Download Production Files"),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ready for Manufacturing?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF064E3B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Export complete specifications and place your order with confidence.",
            style: TextStyle(fontSize: 11, color: Color(0xFF065F46)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: widget.onPlaceOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Center(child: Text("Place Manufacturing Order")),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("♻️", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sustainable Production",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  "Visualizing before manufacturing reduces waste. Optimized for efficient material usage.",
                  style: TextStyle(fontSize: 10, color: Colors.amber.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatItem extends StatelessWidget {
  final String title;
  final String sub;
  const _FormatItem({required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
