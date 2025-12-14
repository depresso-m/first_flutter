import 'package:drift/drift.dart';

import '../../../../core/models/cart_item.dart';
import '../../../../core/models/medicine.dart';
import '../cart_local_datasource.dart';
import 'database.dart';

class CartDriftDataSourceImpl implements CartLocalDataSource {
  final AppDatabase _database;

  CartDriftDataSourceImpl({required AppDatabase database})
    : _database = database;

  @override
  Future<List<CartItem>> getCartItems() async {
    final items = await _database.select(_database.cartItems).get();
    return items.map((item) => _cartItemFromDb(item)).toList();
  }

  @override
  Future<void> addToCart(Medicine medicine) async {
    final existing = await (_database.select(
      _database.cartItems,
    )..where((tbl) => tbl.medicineId.equals(medicine.id))).getSingleOrNull();

    if (existing != null) {
      await (_database.update(_database.cartItems)
            ..where((tbl) => tbl.medicineId.equals(medicine.id)))
          .write(CartItemsCompanion(quantity: Value(existing.quantity + 1)));
    } else {
      await _database
          .into(_database.cartItems)
          .insert(
            CartItemsCompanion.insert(
              medicineId: medicine.id,
              medicineName: medicine.name,
              medicineDescription: Value(medicine.description),
              medicinePrice: medicine.price,
              medicineImageUrl: Value(medicine.imageUrl),
              medicineManufacturer: Value(medicine.manufacturer),
              quantity: const Value(1),
            ),
          );
    }
  }

  @override
  Future<void> updateQuantity(String medicineId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(medicineId);
      return;
    }

    await (_database.update(_database.cartItems)
          ..where((tbl) => tbl.medicineId.equals(medicineId)))
        .write(CartItemsCompanion(quantity: Value(quantity)));
  }

  @override
  Future<void> removeFromCart(String medicineId) async {
    await (_database.delete(
      _database.cartItems,
    )..where((tbl) => tbl.medicineId.equals(medicineId))).go();
  }

  @override
  Future<void> clearCart() async {
    await _database.delete(_database.cartItems).go();
  }

  CartItem _cartItemFromDb(CartItemsData item) {
    final medicine = Medicine(
      id: item.medicineId,
      name: item.medicineName,
      description: item.medicineDescription,
      price: item.medicinePrice,
      imageUrl: item.medicineImageUrl,
      manufacturer: item.medicineManufacturer,
    );

    return CartItem(medicine: medicine, quantity: item.quantity);
  }
}
