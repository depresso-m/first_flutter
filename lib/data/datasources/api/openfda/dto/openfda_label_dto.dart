/// DTO for OpenFDA drug label response
class OpenFdaLabelResponseDto {
  final List<OpenFdaLabelDto> results;

  const OpenFdaLabelResponseDto({required this.results});

  factory OpenFdaLabelResponseDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaLabelResponseDto(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OpenFdaLabelDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// DTO for drug label information
class OpenFdaLabelDto {
  final String? id;
  final List<String>? indications;
  final List<String>? dosageAndAdministration;
  final List<String>? warnings;
  final List<String>? adverseReactions;
  final List<String>? drugInteractions;
  final List<String>? contraindications;
  final List<String>? instructions;
  final List<String>? description;
  final List<String>? purpose;
  final List<String>? activeIngredient;
  final List<String>? inactiveIngredient;
  final List<String>? storageAndHandling;
  final OpenFdaLabelInfoDto? openfda;

  const OpenFdaLabelDto({
    this.id,
    this.indications,
    this.dosageAndAdministration,
    this.warnings,
    this.adverseReactions,
    this.drugInteractions,
    this.contraindications,
    this.instructions,
    this.description,
    this.purpose,
    this.activeIngredient,
    this.inactiveIngredient,
    this.storageAndHandling,
    this.openfda,
  });

  factory OpenFdaLabelDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaLabelDto(
      id: json['id'] as String?,
      indications: _parseStringList(json['indications_and_usage']),
      dosageAndAdministration:
          _parseStringList(json['dosage_and_administration']),
      warnings: _parseStringList(json['warnings']),
      adverseReactions: _parseStringList(json['adverse_reactions']),
      drugInteractions: _parseStringList(json['drug_interactions']),
      contraindications: _parseStringList(json['contraindications']),
      instructions: _parseStringList(json['instructions_for_use']),
      description: _parseStringList(json['description']),
      purpose: _parseStringList(json['purpose']),
      activeIngredient: _parseStringList(json['active_ingredient']),
      inactiveIngredient: _parseStringList(json['inactive_ingredient']),
      storageAndHandling: _parseStringList(json['storage_and_handling']),
      openfda: json['openfda'] != null
          ? OpenFdaLabelInfoDto.fromJson(json['openfda'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}

/// DTO for openfda block in label
class OpenFdaLabelInfoDto {
  final List<String>? brandName;
  final List<String>? genericName;
  final List<String>? manufacturerName;
  final List<String>? productNdc;
  final List<String>? substanceName;
  final List<String>? route;

  const OpenFdaLabelInfoDto({
    this.brandName,
    this.genericName,
    this.manufacturerName,
    this.productNdc,
    this.substanceName,
    this.route,
  });

  factory OpenFdaLabelInfoDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaLabelInfoDto(
      brandName: _parseStringList(json['brand_name']),
      genericName: _parseStringList(json['generic_name']),
      manufacturerName: _parseStringList(json['manufacturer_name']),
      productNdc: _parseStringList(json['product_ndc']),
      substanceName: _parseStringList(json['substance_name']),
      route: _parseStringList(json['route']),
    );
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}
