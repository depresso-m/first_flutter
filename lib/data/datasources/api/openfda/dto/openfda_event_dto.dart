/// DTO for OpenFDA adverse event response
class OpenFdaEventResponseDto {
  final List<OpenFdaEventDto> results;

  const OpenFdaEventResponseDto({required this.results});

  factory OpenFdaEventResponseDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaEventResponseDto(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OpenFdaEventDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// DTO for adverse event
class OpenFdaEventDto {
  final String? safetyReportId;
  final String? receiveDate;
  final String? serious;
  final PatientDto? patient;

  const OpenFdaEventDto({
    this.safetyReportId,
    this.receiveDate,
    this.serious,
    this.patient,
  });

  factory OpenFdaEventDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaEventDto(
      safetyReportId: json['safetyreportid'] as String?,
      receiveDate: json['receivedate'] as String?,
      serious: json['serious'] as String?,
      patient: json['patient'] != null
          ? PatientDto.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// DTO for patient in adverse event
class PatientDto {
  final List<ReactionDto>? reactions;
  final List<DrugDto>? drugs;

  const PatientDto({this.reactions, this.drugs});

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      reactions: (json['reaction'] as List<dynamic>?)
          ?.map((e) => ReactionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      drugs: (json['drug'] as List<dynamic>?)
          ?.map((e) => DrugDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// DTO for reaction
class ReactionDto {
  final String? reactionMedDrapt;
  final String? reactionOutcome;

  const ReactionDto({this.reactionMedDrapt, this.reactionOutcome});

  factory ReactionDto.fromJson(Map<String, dynamic> json) {
    return ReactionDto(
      reactionMedDrapt: json['reactionmeddrapt'] as String?,
      reactionOutcome: json['reactionoutcome'] as String?,
    );
  }
}

/// DTO for drug in adverse event
class DrugDto {
  final String? drugCharacterization;
  final String? medicinalProduct;
  final DrugOpenFdaDto? openfda;

  const DrugDto({
    this.drugCharacterization,
    this.medicinalProduct,
    this.openfda,
  });

  factory DrugDto.fromJson(Map<String, dynamic> json) {
    return DrugDto(
      drugCharacterization: json['drugcharacterization'] as String?,
      medicinalProduct: json['medicinalproduct'] as String?,
      openfda: json['openfda'] != null
          ? DrugOpenFdaDto.fromJson(json['openfda'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// DTO for openfda in drug
class DrugOpenFdaDto {
  final List<String>? brandName;
  final List<String>? genericName;

  const DrugOpenFdaDto({this.brandName, this.genericName});

  factory DrugOpenFdaDto.fromJson(Map<String, dynamic> json) {
    return DrugOpenFdaDto(
      brandName: _parseStringList(json['brand_name']),
      genericName: _parseStringList(json['generic_name']),
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
