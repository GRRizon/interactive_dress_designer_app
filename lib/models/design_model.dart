class DesignModel {
  final String color;
  final String fabric;
  final String sleeve;
  final String neckline;
  final String pattern;
  final String length;
  final List<Modification> modifications;

  DesignModel({
    required this.color,
    required this.fabric,
    required this.sleeve,
    required this.neckline,
    required this.pattern,
    required this.length,
    this.modifications = const [],
  });

  // Copy with method for immutability
  DesignModel copyWith({
    String? color,
    String? fabric,
    String? sleeve,
    String? neckline,
    String? pattern,
    String? length,
    List<Modification>? modifications,
  }) {
    return DesignModel(
      color: color ?? this.color,
      fabric: fabric ?? this.fabric,
      sleeve: sleeve ?? this.sleeve,
      neckline: neckline ?? this.neckline,
      pattern: pattern ?? this.pattern,
      length: length ?? this.length,
      modifications: modifications ?? this.modifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'fabric': fabric,
      'sleeve': sleeve,
      'neckline': neckline,
      'pattern': pattern,
      'length': length,
      'modifications': modifications.map((m) => m.toJson()).toList(),
    };
  }

  factory DesignModel.fromJson(Map<String, dynamic> json) {
    return DesignModel(
      color: json['color'],
      fabric: json['fabric'],
      sleeve: json['sleeve'],
      neckline: json['neckline'],
      pattern: json['pattern'],
      length: json['length'],
      modifications:
          (json['modifications'] as List<dynamic>?)
              ?.map((m) => Modification.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Modification {
  String part;
  String attribute;
  String value;

  Modification({
    required this.part,
    required this.attribute,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {'part': part, 'attribute': attribute, 'value': value};
  }

  factory Modification.fromJson(Map<String, dynamic> json) {
    return Modification(
      part: json['part'],
      attribute: json['attribute'],
      value: json['value'],
    );
  }
}
