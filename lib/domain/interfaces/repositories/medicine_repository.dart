import '../../../core/models/medicine.dart';
import '../../../data/mappers/medicine_mapper.dart';

abstract class MedicineRepository {
  // Existing local methods
  Future<List<Medicine>> getAllMedicines();

  Future<Medicine?> getMedicineById(String id);

  Future<List<Medicine>> searchMedicines(String query);

  Future<List<Medicine>> getMedicinesByPriceRange(double minPrice, double maxPrice);

  Future<List<Medicine>> getMedicinesSortedByPrice({bool ascending = true});

  // OpenFDA API methods
  /// Fetch random medicines from OpenFDA API
  Future<List<Medicine>> getRandomMedicinesFromApi({int skip = 0, int limit = 10});

  /// Search medicines by name using OpenFDA API
  Future<List<Medicine>> searchMedicinesFromApi(String query);

  /// Get detailed medicine information (label) by NDC
  Future<MedicineDetails?> getMedicineDetails(String ndc);

  /// Get medicine analogs by active ingredient
  Future<List<Medicine>> getAnalogs(String activeIngredient);

  /// Get side effects (adverse events) by brand name
  Future<List<String>> getSideEffects(String brandName);

  /// Get drugs from a specific manufacturer
  Future<List<Medicine>> getDrugsByManufacturer(String manufacturerName);
}
