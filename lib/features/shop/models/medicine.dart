class Medicine {
  final String name;
  final double price;
  final String? imageUrl;

  Medicine({required this.name, required this.price, this.imageUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicine &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ imageUrl.hashCode;
}
