class Medicine {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? manufacturer;
  
  // OpenFDA fields
  final String? brandName;
  final String? genericName;
  final String? activeIngredient;
  final String? ndc; // National Drug Code
  final String? dosageForm;
  final String? route;
  final String? pharmClass;
  final List<String>? sideEffects;
  final List<String>? analogs;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.manufacturer,
    this.brandName,
    this.genericName,
    this.activeIngredient,
    this.ndc,
    this.dosageForm,
    this.route,
    this.pharmClass,
    this.sideEffects,
    this.analogs,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Название лекарства не может быть пустым');
    }
    if (price < 0) {
      throw ArgumentError('Цена не может быть отрицательной');
    }
  }

  bool get isExpensive => price > 1000;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  String get priceFormatted => '${price.toStringAsFixed(2)} ₽';

  /// Display name - prefers brand name, falls back to generic name or name
  String get displayName {
    if (brandName != null && brandName!.isNotEmpty) return brandName!;
    if (genericName != null && genericName!.isNotEmpty) return genericName!;
    return name;
  }

  /// Subtitle for list display - shows generic name or active ingredient
  String? get subtitle {
    if (genericName != null && 
        genericName!.isNotEmpty && 
        genericName != brandName) {
      return genericName;
    }
    return activeIngredient;
  }

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        (description?.toLowerCase().contains(lowerQuery) ?? false) ||
        (manufacturer?.toLowerCase().contains(lowerQuery) ?? false) ||
        (brandName?.toLowerCase().contains(lowerQuery) ?? false) ||
        (genericName?.toLowerCase().contains(lowerQuery) ?? false) ||
        (activeIngredient?.toLowerCase().contains(lowerQuery) ?? false);
  }

  Medicine copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    String? manufacturer,
    String? brandName,
    String? genericName,
    String? activeIngredient,
    String? ndc,
    String? dosageForm,
    String? route,
    String? pharmClass,
    List<String>? sideEffects,
    List<String>? analogs,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      brandName: brandName ?? this.brandName,
      genericName: genericName ?? this.genericName,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      ndc: ndc ?? this.ndc,
      dosageForm: dosageForm ?? this.dosageForm,
      route: route ?? this.route,
      pharmClass: pharmClass ?? this.pharmClass,
      sideEffects: sideEffects ?? this.sideEffects,
      analogs: analogs ?? this.analogs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Medicine(id: $id, name: $name, price: $price)';
}
