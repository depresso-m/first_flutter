import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/pharmacy.dart';

part 'pharmacies_provider.g.dart';

final List<Pharmacy> _initialPharmacies = [
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

@Riverpod(keepAlive: true)
class PharmaciesNotifier extends _$PharmaciesNotifier {
  @override
  List<Pharmacy> build() {
    return _initialPharmacies;
  }
}

