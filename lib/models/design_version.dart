import 'design_model.dart';

class DesignVersion {
  final String id;
  final int version;
  final String? parentId;
  final DateTime timestamp;
  final String description;
  final bool isFavorite;
  final DesignModel config;
  final List<Modification> modifications;

  DesignVersion({
    required this.id,
    required this.version,
    this.parentId,
    required this.timestamp,
    required this.description,
    this.isFavorite = false,
    required this.config,
    this.modifications = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'parentId': parentId,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'isFavorite': isFavorite,
      'config': config.toJson(),
      'modifications': modifications.map((m) => m.toJson()).toList(),
    };
  }

  factory DesignVersion.fromJson(Map<String, dynamic> json) {
    return DesignVersion(
      id: json['id'],
      version: json['version'],
      parentId: json['parentId'],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
      config: DesignModel.fromJson(json['config']),
      modifications:
          (json['modifications'] as List<dynamic>?)
              ?.map((m) => Modification.fromJson(m))
              .toList() ??
          [],
    );
  }
}
