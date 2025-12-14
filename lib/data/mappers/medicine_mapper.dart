import 'dart:math';

import '../../core/models/medicine.dart';
import '../datasources/api/openfda/dto/openfda_drug_dto.dart';
import '../datasources/api/openfda/dto/openfda_label_dto.dart';

/// Mapper for converting OpenFDA DTOs to Medicine entities
class MedicineMapper {
  static final _random = Random();

  /// Convert OpenFdaDrugDto to Medicine
  static Medicine fromDrugDto(OpenFdaDrugDto dto, {double? price}) {
    final brandName = dto.openfda?.brandName?.firstOrNull ?? '';
    final genericName = dto.openfda?.genericName?.firstOrNull ?? '';
    final name = brandName.isNotEmpty ? brandName : genericName;

    // Get dosage form from products if available
    String? dosageForm;
    if (dto.products != null && dto.products!.isNotEmpty) {
      dosageForm = dto.products!.first.dosageForm;
    }

    // Get active ingredient from products or openfda
    String? activeIngredient;
    if (dto.products != null &&
        dto.products!.isNotEmpty &&
        dto.products!.first.activeIngredients != null &&
        dto.products!.first.activeIngredients!.isNotEmpty) {
      final ingredient = dto.products!.first.activeIngredients!.first;
      activeIngredient = ingredient.name;
      if (ingredient.strength != null) {
        activeIngredient = '${ingredient.name} (${ingredient.strength})';
      }
    } else {
      activeIngredient = dto.openfda?.substanceName?.firstOrNull;
    }

    return Medicine(
      id: dto.applicationNumber ?? _generateId(),
      name: name.isEmpty ? 'Unknown Drug' : (_capitalizeWords(name) ?? name),
      brandName: _capitalizeWords(brandName),
      genericName: _capitalizeWords(genericName),
      price: price ?? _generateRealisticPrice(),
      manufacturer: _capitalizeWords(
        dto.openfda?.manufacturerName?.firstOrNull ?? dto.sponsorName,
      ),
      activeIngredient: activeIngredient,
      ndc: dto.openfda?.productNdc?.firstOrNull,
      dosageForm: dosageForm,
      route: dto.openfda?.route?.firstOrNull,
      pharmClass: dto.openfda?.pharmClassEpc?.firstOrNull,
    );
  }

  /// Convert list of DTOs to Medicines
  static List<Medicine> fromDrugDtoList(List<OpenFdaDrugDto> dtos) {
    return dtos
        .where((dto) =>
            dto.openfda?.brandName?.isNotEmpty == true ||
            dto.openfda?.genericName?.isNotEmpty == true)
        .map((dto) => fromDrugDto(dto))
        .toList();
  }

  /// Create MedicineDetails from label DTO
  static MedicineDetails fromLabelDto(OpenFdaLabelDto dto) {
    return MedicineDetails(
      indications: dto.indications?.firstOrNull,
      dosageAndAdministration: dto.dosageAndAdministration?.firstOrNull,
      warnings: dto.warnings?.firstOrNull,
      adverseReactions: dto.adverseReactions?.firstOrNull,
      drugInteractions: dto.drugInteractions?.firstOrNull,
      contraindications: dto.contraindications?.firstOrNull,
      description: dto.description?.firstOrNull,
      storageAndHandling: dto.storageAndHandling?.firstOrNull,
    );
  }

  /// Generate a realistic price in rubles
  static double _generateRealisticPrice() {
    // Prices range from 50 to 5000 rubles with some common values
    final priceRanges = [
      (50.0, 200.0, 0.3), // 30% cheap
      (200.0, 800.0, 0.4), // 40% medium
      (800.0, 2000.0, 0.2), // 20% expensive
      (2000.0, 5000.0, 0.1), // 10% premium
    ];

    final roll = _random.nextDouble();
    double cumulative = 0;

    for (final (min, max, probability) in priceRanges) {
      cumulative += probability;
      if (roll < cumulative) {
        final price = min + _random.nextDouble() * (max - min);
        // Round to .00, .50, or .99
        final rounded = (price / 50).round() * 50;
        return rounded.toDouble();
      }
    }

    return 500.0;
  }

  static String _generateId() {
    return 'GEN${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  static String? _capitalizeWords(String? text) {
    if (text == null || text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}

/// Additional medicine details from label
class MedicineDetails {
  final String? indications;
  final String? dosageAndAdministration;
  final String? warnings;
  final String? adverseReactions;
  final String? drugInteractions;
  final String? contraindications;
  final String? description;
  final String? storageAndHandling;

  const MedicineDetails({
    this.indications,
    this.dosageAndAdministration,
    this.warnings,
    this.adverseReactions,
    this.drugInteractions,
    this.contraindications,
    this.description,
    this.storageAndHandling,
  });

  bool get hasAnyData =>
      indications != null ||
      dosageAndAdministration != null ||
      warnings != null ||
      adverseReactions != null ||
      description != null;
}
