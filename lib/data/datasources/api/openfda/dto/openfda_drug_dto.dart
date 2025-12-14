/// DTO for OpenFDA drug response
class OpenFdaResponseDto {
  final List<OpenFdaDrugDto> results;
  final OpenFdaMetaDto? meta;

  const OpenFdaResponseDto({
    required this.results,
    this.meta,
  });

  factory OpenFdaResponseDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaResponseDto(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OpenFdaDrugDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null
          ? OpenFdaMetaDto.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// DTO for OpenFDA metadata
class OpenFdaMetaDto {
  final int? skip;
  final int? limit;
  final int? total;

  const OpenFdaMetaDto({this.skip, this.limit, this.total});

  factory OpenFdaMetaDto.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>?;
    return OpenFdaMetaDto(
      skip: results?['skip'] as int?,
      limit: results?['limit'] as int?,
      total: results?['total'] as int?,
    );
  }
}

/// DTO for a single drug from OpenFDA
class OpenFdaDrugDto {
  final String? applicationNumber;
  final String? sponsorName;
  final OpenFdaInfoDto? openfda;
  final List<ProductDto>? products;
  final List<SubmissionDto>? submissions;

  const OpenFdaDrugDto({
    this.applicationNumber,
    this.sponsorName,
    this.openfda,
    this.products,
    this.submissions,
  });

  factory OpenFdaDrugDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaDrugDto(
      applicationNumber: json['application_number'] as String?,
      sponsorName: json['sponsor_name'] as String?,
      openfda: json['openfda'] != null
          ? OpenFdaInfoDto.fromJson(json['openfda'] as Map<String, dynamic>)
          : null,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      submissions: (json['submissions'] as List<dynamic>?)
          ?.map((e) => SubmissionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// DTO for OpenFDA info block
class OpenFdaInfoDto {
  final List<String>? brandName;
  final List<String>? genericName;
  final List<String>? manufacturerName;
  final List<String>? substanceName;
  final List<String>? productNdc;
  final List<String>? productType;
  final List<String>? route;
  final List<String>? pharmClassEpc;

  const OpenFdaInfoDto({
    this.brandName,
    this.genericName,
    this.manufacturerName,
    this.substanceName,
    this.productNdc,
    this.productType,
    this.route,
    this.pharmClassEpc,
  });

  factory OpenFdaInfoDto.fromJson(Map<String, dynamic> json) {
    return OpenFdaInfoDto(
      brandName: _parseStringList(json['brand_name']),
      genericName: _parseStringList(json['generic_name']),
      manufacturerName: _parseStringList(json['manufacturer_name']),
      substanceName: _parseStringList(json['substance_name']),
      productNdc: _parseStringList(json['product_ndc']),
      productType: _parseStringList(json['product_type']),
      route: _parseStringList(json['route']),
      pharmClassEpc: _parseStringList(json['pharm_class_epc']),
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

/// DTO for product information
class ProductDto {
  final String? productNumber;
  final String? referenceDrug;
  final String? brandName;
  final List<ActiveIngredientDto>? activeIngredients;
  final String? referenceListed;
  final String? dosageForm;
  final String? route;
  final String? marketingStatus;

  const ProductDto({
    this.productNumber,
    this.referenceDrug,
    this.brandName,
    this.activeIngredients,
    this.referenceListed,
    this.dosageForm,
    this.route,
    this.marketingStatus,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productNumber: json['product_number'] as String?,
      referenceDrug: json['reference_drug'] as String?,
      brandName: json['brand_name'] as String?,
      activeIngredients: (json['active_ingredients'] as List<dynamic>?)
          ?.map((e) => ActiveIngredientDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      referenceListed: json['reference_listed_drug'] as String?,
      dosageForm: json['dosage_form'] as String?,
      route: json['route'] as String?,
      marketingStatus: json['marketing_status'] as String?,
    );
  }
}

/// DTO for active ingredients
class ActiveIngredientDto {
  final String? name;
  final String? strength;

  const ActiveIngredientDto({this.name, this.strength});

  factory ActiveIngredientDto.fromJson(Map<String, dynamic> json) {
    return ActiveIngredientDto(
      name: json['name'] as String?,
      strength: json['strength'] as String?,
    );
  }
}

/// DTO for submissions
class SubmissionDto {
  final String? submissionType;
  final String? submissionNumber;
  final String? submissionStatus;
  final String? submissionStatusDate;

  const SubmissionDto({
    this.submissionType,
    this.submissionNumber,
    this.submissionStatus,
    this.submissionStatusDate,
  });

  factory SubmissionDto.fromJson(Map<String, dynamic> json) {
    return SubmissionDto(
      submissionType: json['submission_type'] as String?,
      submissionNumber: json['submission_number'] as String?,
      submissionStatus: json['submission_status'] as String?,
      submissionStatusDate: json['submission_status_date'] as String?,
    );
  }
}
