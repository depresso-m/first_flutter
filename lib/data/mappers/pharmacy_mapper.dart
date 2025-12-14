import '../../core/models/pharmacy.dart';
import '../datasources/api/overpass/dto/overpass_pharmacy_dto.dart';

/// Mapper for converting Overpass DTOs to Pharmacy entities
class PharmacyMapper {
  /// Convert OverpassElementDto to Pharmacy
  static Pharmacy fromOverpassDto(OverpassElementDto dto) {
    final tags = dto.tags;
    
    // Build address from tags
    String address = 'Адрес не указан';
    if (tags != null) {
      address = tags.fullAddress;
    }

    // Get opening hours
    String workingHours = 'Время работы не указано';
    if (tags?.openingHours != null) {
      workingHours = _formatOpeningHours(tags!.openingHours!);
    }

    // Get phone
    String phone = 'Телефон не указан';
    if (tags?.phone != null) {
      phone = tags!.phone!;
    }

    // Generate email from website or leave empty
    String email = '';
    if (tags?.website != null) {
      email = tags!.website!;
    }

    return Pharmacy(
      id: 'osm_${dto.type}_${dto.id}',
      name: tags?.displayName ?? 'Аптека',
      address: address,
      workingHours: workingHours,
      phone: phone,
      email: email,
      latitude: dto.lat,
      longitude: dto.lon,
      operator: tags?.operator,
      brand: tags?.brand,
      website: tags?.website,
      isWheelchairAccessible: tags?.wheelchair == 'yes',
    );
  }

  /// Convert list of DTOs to Pharmacies
  static List<Pharmacy> fromOverpassDtoList(List<OverpassElementDto> dtos) {
    return dtos
        .where((dto) => dto.lat != 0 && dto.lon != 0)
        .map(fromOverpassDto)
        .toList();
  }

  /// Format opening hours from OSM format to readable Russian format
  static String _formatOpeningHours(String hours) {
    // Basic formatting - OSM uses specific format like "Mo-Fr 09:00-21:00; Sa 10:00-18:00"
    if (hours.toLowerCase().contains('24/7')) {
      return 'Круглосуточно';
    }

    // Replace day abbreviations with Russian
    return hours
        .replaceAll('Mo', 'Пн')
        .replaceAll('Tu', 'Вт')
        .replaceAll('We', 'Ср')
        .replaceAll('Th', 'Чт')
        .replaceAll('Fr', 'Пт')
        .replaceAll('Sa', 'Сб')
        .replaceAll('Su', 'Вс')
        .replaceAll('PH', 'праздн.')
        .replaceAll('off', 'выходной');
  }
}
