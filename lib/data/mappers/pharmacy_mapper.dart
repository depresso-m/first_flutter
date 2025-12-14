import '../../core/models/pharmacy.dart';
import '../datasources/api/overpass/dto/overpass_pharmacy_dto.dart';

/// Extension для преобразования OverpassElementDto в Pharmacy
extension OverpassElementDtoMapper on OverpassElementDto {
  /// Преобразует DTO в бизнес-модель Pharmacy
  Pharmacy toModel() {
    // Формируем адрес из тегов
    final address = _buildAddress();
    
    // Формируем часы работы
    final workingHours = tags?.openingHours ?? 'Не указано';
    
    // Формируем телефон
    final phone = tags?.phone ?? '+7 (000) 000-00-00';
    
    // Формируем email (если нет, используем дефолтный)
    final email = tags?.website != null 
        ? 'info@${tags!.website!.replaceAll(RegExp(r'^https?://'), '').split('/').first}'
        : 'info@pharmacy.ru';

    return Pharmacy(
      id: 'osm_${type}_$id',
      name: tags?.displayName,
      address: address,
      workingHours: workingHours,
      phone: phone,
      email: email,
      latitude: lat != 0 ? lat : null,
      longitude: lon != 0 ? lon : null,
      operator: tags?.operator,
      brand: tags?.brand,
      website: tags?.website,
      isWheelchairAccessible: tags?.wheelchair == 'yes',
    );
  }

  String _buildAddress() {
    if (tags == null) return 'Адрес не указан';
    
    // Используем полный адрес если есть
    if (tags!.addrFull != null && tags!.addrFull!.isNotEmpty) {
      return tags!.addrFull!;
    }
    
    // Иначе собираем из частей
    final parts = <String>[];
    if (tags!.addrCity != null) parts.add(tags!.addrCity!);
    if (tags!.addrStreet != null) parts.add(tags!.addrStreet!);
    if (tags!.addrHousenumber != null) {
      parts.add('д. ${tags!.addrHousenumber}');
    }
    if (tags!.addrPostcode != null) {
      parts.add('${tags!.addrPostcode}');
    }
    
    return parts.isNotEmpty ? parts.join(', ') : 'Адрес не указан';
  }
}

/// Extension для преобразования списка DTO в список моделей
extension OverpassElementDtoListMapper on List<OverpassElementDto> {
  /// Преобразует список DTO в список Pharmacy
  List<Pharmacy> toModelList() {
    return map((dto) => dto.toModel()).toList();
  }
}
