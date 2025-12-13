class Medicine {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? manufacturer;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.manufacturer,
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

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        (description?.toLowerCase().contains(lowerQuery) ?? false) ||
        (manufacturer?.toLowerCase().contains(lowerQuery) ?? false);
  }

  Medicine copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    String? manufacturer,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
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
