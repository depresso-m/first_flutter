import '../../core/models/medicine.dart';
import '../../domain/interfaces/repositories/medicine_repository.dart';
import '../datasources/api/medicine_api_datasource.dart';
import '../datasources/local/medicine_local_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineApiDataSource _apiDataSource;
  final MedicineLocalDataSource _localDataSource;

  MedicineRepositoryImpl({
    required MedicineApiDataSource apiDataSource,
    required MedicineLocalDataSource localDataSource,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Medicine>> getAllMedicines() async {
    try {
      final medicines = await _apiDataSource.getAllMedicines();
      await _localDataSource.saveMedicines(medicines);
      return medicines;
    } catch (_) {
      return await _localDataSource.getAllMedicines();
    }
  }

  @override
  Future<Medicine?> getMedicineById(String id) async {
    try {
      final medicine = await _apiDataSource.getMedicineById(id);
      if (medicine != null) {
        await _localDataSource.saveMedicine(medicine);
      }
      return medicine;
    } catch (_) {
      return await _localDataSource.getMedicineById(id);
    }
  }

  @override
  Future<List<Medicine>> searchMedicines(String query) async {
    final allMedicines = await getAllMedicines();
    if (query.trim().isEmpty) return allMedicines;

    return allMedicines.where((m) => m.matchesQuery(query)).toList();
  }

  @override
  Future<List<Medicine>> getMedicinesByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    final allMedicines = await getAllMedicines();
    return allMedicines
        .where((m) => m.price >= minPrice && m.price <= maxPrice)
        .toList();
  }

  @override
  Future<List<Medicine>> getMedicinesSortedByPrice({bool ascending = true}) async {
    final medicines = await getAllMedicines();
    medicines.sort((a, b) =>
        ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    return medicines;
  }
}
