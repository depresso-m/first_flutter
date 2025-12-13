import '../../../core/models/pharmacy.dart';

abstract class PharmacyApiDataSource {
  Future<List<Pharmacy>> getAllPharmacies();
  Future<Pharmacy?> getPharmacyById(String id);
}

class PharmacyApiDataSourceImpl implements PharmacyApiDataSource {
  static const List<Pharmacy> _mockPharmacies = [
    Pharmacy(
      id: '1',
      address: 'ул. Ленина, 15',
      workingHours: '08:00 - 22:00',
      phone: '+7 (495) 123-45-67',
      email: 'lenina15@pharmacy.ru',
    ),
    Pharmacy(
      id: '2',
      address: 'пр. Мира, 42',
      workingHours: '09:00 - 21:00',
      phone: '+7 (495) 234-56-78',
      email: 'mira42@pharmacy.ru',
    ),
    Pharmacy(
      id: '3',
      address: 'ул. Пушкина, 8',
      workingHours: 'Круглосуточно',
      phone: '+7 (495) 345-67-89',
      email: 'pushkina8@pharmacy.ru',
    ),
    Pharmacy(
      id: '4',
      address: 'ул. Гагарина, 100',
      workingHours: '08:00 - 20:00',
      phone: '+7 (495) 456-78-90',
      email: 'gagarina100@pharmacy.ru',
    ),
    Pharmacy(
      id: '5',
      address: 'Комсомольский пр., 25',
      workingHours: '10:00 - 22:00',
      phone: '+7 (495) 567-89-01',
      email: 'komsomolsky25@pharmacy.ru',
    ),
  ];

  @override
  Future<List<Pharmacy>> getAllPharmacies() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_mockPharmacies);
  }

  @override
  Future<Pharmacy?> getPharmacyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _mockPharmacies.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
