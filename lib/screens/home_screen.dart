import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/design_model.dart';
import '../models/design_version.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';
import '../widgets/dress_preview.dart';
import '../widgets/customization_panel.dart';
import '../widgets/ai_suggestion.dart';
import '../widgets/localized_modification.dart';
import '../widgets/design_genealogy.dart';
import '../widgets/design_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DesignModel currentDesign = DesignModel(
    color: '#DC143C',
    fabric: 'silk',
    sleeve: 'sleeveless',
    neckline: 'v-neck',
    pattern: 'solid',
    length: 'midi',
  );
  List<DesignVersion> versions = [];
  String? currentVersionId;
  bool isGenerating = false;
  String skinTone = '#F5D7B1';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load biometric data
    final savedBiometric = prefs.getString('biometricData');
    if (savedBiometric != null) {
      final biometric = jsonDecode(savedBiometric);
      if (!mounted) return;
      setState(() {
        skinTone = biometric['skinTone'] ?? '#F5D7B1';
      });
    }

    // Load design history
    final savedHistory = prefs.getString('designHistory');
    if (savedHistory != null) {
      final history = jsonDecode(savedHistory) as List;
      if (!mounted) return;
      setState(() {
        versions = history.map((v) => DesignVersion.fromJson(v)).toList();
        if (versions.isNotEmpty) {
          currentVersionId = versions.first.id;
          currentDesign = versions.first.config;
        } else {
          _initializeDesign();
        }
      });
    } else {
      _initializeDesign();
    }
  }

  void _initializeDesign() {
    currentDesign = DesignModel(
      color: '#DC143C',
      fabric: 'silk',
      sleeve: 'sleeveless',
      neckline: 'v-neck',
      pattern: 'solid',
      length: 'midi',
    );
    _createVersion('Initial Design');
  }

  void _createVersion(String description, {String? parentId}) {
    final newVersion = DesignVersion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      version: versions.length + 1,
      parentId: parentId,
      timestamp: DateTime.now(),
      description: description,
      config: currentDesign,
      modifications: currentDesign.modifications,
    );

    setState(() {
      versions.insert(0, newVersion);
      currentVersionId = newVersion.id;
    });

    _saveVersions();
  }

  Future<void> _saveVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = versions.map((v) => v.toJson()).toList();
    await prefs.setString('designHistory', jsonEncode(historyJson));
  }

  void updateDesign(DesignModel newDesign) {
    setState(() {
      currentDesign = newDesign;
    });
  }

  void _generateAI() {
    setState(() {
      isGenerating = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final geminiDesign = DesignModel(
        color: '#9370DB',
        fabric: 'satin',
        sleeve: 'three-quarter',
        neckline: 'sweetheart',
        pattern: 'floral',
        length: 'midi',
      );

      setState(() {
        currentDesign = geminiDesign;
        isGenerating = false;
      });

      _createVersion('Gemini AI Generated Design');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gemini created a fresh design for you!')),
      );
    });
  }

  void _randomize() {
    final randomDesign = DesignModel(
      color: '#4169E1', // Random color
      fabric: 'velvet',
      sleeve: 'cap',
      neckline: 'boat',
      pattern: 'floral',
      length: 'maxi',
    );
    updateDesign(randomDesign);
    _createVersion('Randomized Design');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isAuthenticated) {
      return const AuthScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Fashion Designer'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Design'),
            Tab(text: 'Modify'),
            Tab(text: 'Genealogy'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDesignTab(),
          _buildModifyTab(),
          _buildGenealogyTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildDesignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DressPreview(
            color: currentDesign.color,
            fabric: currentDesign.fabric,
            sleeve: currentDesign.sleeve,
            neckline: currentDesign.neckline,
            pattern: currentDesign.pattern,
            length: currentDesign.length,
          ),
          const SizedBox(height: 20),
          CustomizationPanel(
            currentDesign: currentDesign,
            onDesignChanged: updateDesign,
            onGenerateAI: _generateAI,
            onRandomize: _randomize,
          ),
          const SizedBox(height: 20),
          AISuggestions(currentDesign: currentDesign),
        ],
      ),
    );
  }

  Widget _buildModifyTab() {
    return LocalizedModification(
      currentDesign: currentDesign,
      onDesignChanged: updateDesign,
      onSaveVersion: () => _createVersion('Modified Design'),
    );
  }

  Widget _buildGenealogyTab() {
    return DesignGenealogy(versions: versions);
  }

  Widget _buildHistoryTab() {
    return DesignHistory(
      versions: versions,
      onVersionSelected: (version) {
        setState(() {
          currentDesign = version.config;
          currentVersionId = version.id;
        });
      },
    );
  }
}
