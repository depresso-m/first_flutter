import '../../../core/models/medicine.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getAllMedicines();

  Future<Medicine?> getMedicineById(String id);

  Future<List<Medicine>> searchMedicines(String query);

  Future<List<Medicine>> getMedicinesByPriceRange(double minPrice, double maxPrice);

  Future<List<Medicine>> getMedicinesSortedByPrice({bool ascending = true});
}
