import 'dart:math';

import '../../core/models/medicine.dart';
import '../datasources/api/openfda/dto/openfda_drug_dto.dart';
import '../datasources/api/openfda/dto/openfda_label_dto.dart';

/// Extension для преобразования OpenFdaDrugDto в Medicine
extension OpenFdaDrugDtoMapper on OpenFdaDrugDto {
  /// Преобразует DTO в бизнес-модель Medicine
  Medicine toModel({double? price}) {
    final brandName = openfda?.brandName?.firstOrNull ?? '';
    final genericName = openfda?.genericName?.firstOrNull ?? '';
    final name = brandName.isNotEmpty ? brandName : genericName;

    // Получаем форму выпуска из products если доступно
    String? dosageForm;
    if (products != null && products!.isNotEmpty) {
      dosageForm = products!.first.dosageForm;
    }

    // Получаем активное вещество из products или openfda
    String? activeIngredient;
    if (products != null &&
        products!.isNotEmpty &&
        products!.first.activeIngredients != null &&
        products!.first.activeIngredients!.isNotEmpty) {
      final ingredient = products!.first.activeIngredients!.first;
      activeIngredient = ingredient.name;
      if (ingredient.strength != null) {
        activeIngredient = '${ingredient.name} (${ingredient.strength})';
      }
    } else {
      activeIngredient = openfda?.substanceName?.firstOrNull;
    }

    return Medicine(
      id: applicationNumber ?? _generateId(),
      name: name.isEmpty ? 'Unknown Drug' : (_capitalizeWords(name) ?? name),
      brandName: _capitalizeWords(brandName),
      genericName: _capitalizeWords(genericName),
      price: price ?? _generateRealisticPrice(),
      manufacturer: _capitalizeWords(
        openfda?.manufacturerName?.firstOrNull ?? sponsorName,
      ),
      activeIngredient: activeIngredient,
      ndc: openfda?.productNdc?.firstOrNull,
      dosageForm: dosageForm,
      route: openfda?.route?.firstOrNull,
      pharmClass: openfda?.pharmClassEpc?.firstOrNull,
    );
  }
}

extension OpenFdaLabelDtoMapper on OpenFdaLabelDto {
  MedicineDetails toModel() {
    return MedicineDetails(
      indications: indications?.firstOrNull,
      dosageAndAdministration: dosageAndAdministration?.firstOrNull,
      warnings: warnings?.firstOrNull,
      adverseReactions: adverseReactions?.firstOrNull,
      drugInteractions: drugInteractions?.firstOrNull,
      contraindications: contraindications?.firstOrNull,
      description: description?.firstOrNull,
      storageAndHandling: storageAndHandling?.firstOrNull,
    );
  }
}

/// Extension для преобразования списка DTO в список моделей
extension OpenFdaDrugDtoListMapper on List<OpenFdaDrugDto> {
  /// Преобразует список DTO в список Medicine
  List<Medicine> toModelList({double? price}) {
    return where((dto) =>
            dto.openfda?.brandName?.isNotEmpty == true ||
            dto.openfda?.genericName?.isNotEmpty == true)
        .map((dto) => dto.toModel(price: price))
        .toList();
  }
}

// Вспомогательные функции
final _random = Random();

double _generateRealisticPrice() {
  final priceRanges = [
    (50.0, 200.0, 0.3),
    (200.0, 800.0, 0.4),
    (800.0, 2000.0, 0.2),
    (2000.0, 5000.0, 0.1),
  ];

  final roll = _random.nextDouble();
  double cumulative = 0;

  for (final (min, max, probability) in priceRanges) {
    cumulative += probability;
    if (roll < cumulative) {
      final price = min + _random.nextDouble() * (max - min);
      final rounded = (price / 50).round() * 50;
      return rounded.toDouble();
    }
  }

  return 500.0;
}

String _generateId() {
  return 'GEN${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
}

String? _capitalizeWords(String? text) {
  if (text == null || text.isEmpty) return text;
  return text
      .toLowerCase()
      .split(' ')
      .map((word) =>
          word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

/// Дополнительная информация о лекарстве из этикетки
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
