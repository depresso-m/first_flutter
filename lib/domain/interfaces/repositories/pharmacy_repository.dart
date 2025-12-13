import '../../../core/models/pharmacy.dart';

abstract class PharmacyRepository {
  Future<List<Pharmacy>> getAllPharmacies();

  Future<Pharmacy?> getPharmacyById(String id);

  Future<List<Pharmacy>> searchPharmacies(String query);

  Future<List<Pharmacy>> getPharmaciesOpen24Hours();
}
