/// DTO for Overpass API response
class OverpassResponseDto {
  final double version;
  final String? generator;
  final List<OverpassElementDto> elements;

  const OverpassResponseDto({
    this.version = 0.6,
    this.generator,
    required this.elements,
  });

  factory OverpassResponseDto.fromJson(Map<String, dynamic> json) {
    return OverpassResponseDto(
      version: (json['version'] as num?)?.toDouble() ?? 0.6,
      generator: json['generator'] as String?,
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) =>
                  OverpassElementDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// DTO for a single element (node/way) from Overpass
class OverpassElementDto {
  final String type;
  final int id;
  final double lat;
  final double lon;
  final OverpassTagsDto? tags;
  final OverpassCenterDto? center; // For ways

  const OverpassElementDto({
    required this.type,
    required this.id,
    required this.lat,
    required this.lon,
    this.tags,
    this.center,
  });

  factory OverpassElementDto.fromJson(Map<String, dynamic> json) {
    // Handle center for ways
    double lat;
    double lon;
    
    if (json['lat'] != null) {
      lat = (json['lat'] as num).toDouble();
      lon = (json['lon'] as num).toDouble();
    } else if (json['center'] != null) {
      final center = json['center'] as Map<String, dynamic>;
      lat = (center['lat'] as num).toDouble();
      lon = (center['lon'] as num).toDouble();
    } else {
      lat = 0;
      lon = 0;
    }

    return OverpassElementDto(
      type: json['type'] as String? ?? 'node',
      id: json['id'] as int? ?? 0,
      lat: lat,
      lon: lon,
      tags: json['tags'] != null
          ? OverpassTagsDto.fromJson(json['tags'] as Map<String, dynamic>)
          : null,
      center: json['center'] != null
          ? OverpassCenterDto.fromJson(json['center'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// DTO for center coordinates (used for ways)
class OverpassCenterDto {
  final double lat;
  final double lon;

  const OverpassCenterDto({required this.lat, required this.lon});

  factory OverpassCenterDto.fromJson(Map<String, dynamic> json) {
    return OverpassCenterDto(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }
}

/// DTO for OSM tags
class OverpassTagsDto {
  final String? name;
  final String? nameRu;
  final String? nameEn;
  final String? amenity;
  final String? openingHours;
  final String? phone;
  final String? website;
  final String? operator;
  final String? brand;
  final String? addrStreet;
  final String? addrHousenumber;
  final String? addrCity;
  final String? addrPostcode;
  final String? addrFull;
  final String? wheelchair;
  final String? description;

  const OverpassTagsDto({
    this.name,
    this.nameRu,
    this.nameEn,
    this.amenity,
    this.openingHours,
    this.phone,
    this.website,
    this.operator,
    this.brand,
    this.addrStreet,
    this.addrHousenumber,
    this.addrCity,
    this.addrPostcode,
    this.addrFull,
    this.wheelchair,
    this.description,
  });

  factory OverpassTagsDto.fromJson(Map<String, dynamic> json) {
    return OverpassTagsDto(
      name: json['name'] as String?,
      nameRu: json['name:ru'] as String?,
      nameEn: json['name:en'] as String?,
      amenity: json['amenity'] as String?,
      openingHours: json['opening_hours'] as String?,
      phone: json['phone'] as String? ?? json['contact:phone'] as String?,
      website: json['website'] as String? ?? json['contact:website'] as String?,
      operator: json['operator'] as String?,
      brand: json['brand'] as String?,
      addrStreet: json['addr:street'] as String?,
      addrHousenumber: json['addr:housenumber'] as String?,
      addrCity: json['addr:city'] as String?,
      addrPostcode: json['addr:postcode'] as String?,
      addrFull: json['addr:full'] as String?,
      wheelchair: json['wheelchair'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Get display name (prefers Russian name)
  String get displayName => nameRu ?? name ?? 'Аптека';

  /// Get full address from tags
  String get fullAddress {
    final parts = <String>[];
    if (addrFull != null) return addrFull!;
    if (addrCity != null) parts.add(addrCity!);
    if (addrStreet != null) parts.add(addrStreet!);
    if (addrHousenumber != null) parts.add('д. $addrHousenumber');
    return parts.isNotEmpty ? parts.join(', ') : 'Адрес не указан';
  }
}
