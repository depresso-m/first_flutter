import '../../../core/models/medicine.dart';

abstract class MedicineLocalDataSource {
  Future<List<Medicine>> getAllMedicines();
  Future<void> saveMedicines(List<Medicine> medicines);
  Future<Medicine?> getMedicineById(String id);
  Future<void> saveMedicine(Medicine medicine);
  Future<void> clear();
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final List<Medicine> _cache = [];

  @override
  Future<List<Medicine>> getAllMedicines() async {
    return List.from(_cache);
  }

  @override
  Future<void> saveMedicines(List<Medicine> medicines) async {
    _cache.clear();
    _cache.addAll(medicines);
  }

  @override
  Future<Medicine?> getMedicineById(String id) async {
    try {
      return _cache.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    final index = _cache.indexWhere((m) => m.id == medicine.id);
    if (index >= 0) {
      _cache[index] = medicine;
    } else {
      _cache.add(medicine);
    }
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }
}
