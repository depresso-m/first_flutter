import '../../../core/models/pharmacy.dart';

abstract class PharmacyLocalDataSource {
  Future<List<Pharmacy>> getAllPharmacies();
  Future<void> savePharmacies(List<Pharmacy> pharmacies);
  Future<Pharmacy?> getPharmacyById(String id);
  Future<void> clear();
}

class PharmacyLocalDataSourceImpl implements PharmacyLocalDataSource {
  final List<Pharmacy> _cache = [];

  @override
  Future<List<Pharmacy>> getAllPharmacies() async {
    return List.from(_cache);
  }

  @override
  Future<void> savePharmacies(List<Pharmacy> pharmacies) async {
    _cache.clear();
    _cache.addAll(pharmacies);
  }

  @override
  Future<Pharmacy?> getPharmacyById(String id) async {
    try {
      return _cache.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }
}
