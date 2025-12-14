/// DTO for Nominatim place response
class NominatimPlaceDto {
  final int placeId;
  final String? licence;
  final String? osmType;
  final int? osmId;
  final String lat;
  final String lon;
  final String? category;
  final String? type;
  final int? placeRank;
  final double? importance;
  final String? addressType;
  final String displayName;
  final String? name;
  final NominatimAddressDto? address;
  final List<String>? boundingBox;

  const NominatimPlaceDto({
    required this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    required this.lat,
    required this.lon,
    this.category,
    this.type,
    this.placeRank,
    this.importance,
    this.addressType,
    required this.displayName,
    this.name,
    this.address,
    this.boundingBox,
  });

  factory NominatimPlaceDto.fromJson(Map<String, dynamic> json) {
    return NominatimPlaceDto(
      placeId: json['place_id'] as int? ?? 0,
      licence: json['licence'] as String?,
      osmType: json['osm_type'] as String?,
      osmId: json['osm_id'] as int?,
      lat: json['lat']?.toString() ?? '0',
      lon: json['lon']?.toString() ?? '0',
      category: json['category'] as String?,
      type: json['type'] as String?,
      placeRank: json['place_rank'] as int?,
      importance: (json['importance'] as num?)?.toDouble(),
      addressType: json['addresstype'] as String?,
      displayName: json['display_name'] as String? ?? '',
      name: json['name'] as String?,
      address: json['address'] != null
          ? NominatimAddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      boundingBox: (json['boundingbox'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  double get latitude => double.tryParse(lat) ?? 0;
  double get longitude => double.tryParse(lon) ?? 0;
}

/// DTO for Nominatim address details
class NominatimAddressDto {
  final String? road;
  final String? houseNumber;
  final String? suburb;
  final String? city;
  final String? town;
  final String? village;
  final String? county;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;

  const NominatimAddressDto({
    this.road,
    this.houseNumber,
    this.suburb,
    this.city,
    this.town,
    this.village,
    this.county,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory NominatimAddressDto.fromJson(Map<String, dynamic> json) {
    return NominatimAddressDto(
      road: json['road'] as String?,
      houseNumber: json['house_number'] as String?,
      suburb: json['suburb'] as String?,
      city: json['city'] as String?,
      town: json['town'] as String?,
      village: json['village'] as String?,
      county: json['county'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }

  /// Get the city name (could be city, town, or village)
  String? get cityName => city ?? town ?? village;
}
