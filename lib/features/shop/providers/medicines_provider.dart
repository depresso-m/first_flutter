import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/medicine.dart';

part 'medicines_provider.g.dart';

final List<Medicine> _initialMedicines = [
  Medicine(
    name: 'Парацетамол',
    price: 120,
    imageUrl:
        "https://cdn.eapteka.ru/upload/offer_photo/234/898/1_7e5109f0fb5a68c6dc68fd151df84d1a.png?t=1634213074&_cvc=1760108554",
  ),
  Medicine(
    name: 'Ибупрофен',
    price: 150,
    imageUrl:
        "https://ozerki.ru/_next/image/?url=https%3A%2F%2Fozerki.ru%2Fer-pics%2Fimages%2Fgoods%2F77719%2Fmain&w=768&q=90",
  ),
  Medicine(
    name: 'Аспирин',
    price: 90,
    imageUrl:
        "https://evropharm.ru/Storage/Resized/w_480/aspirin-bajer-0-5-n20.jpg",
  ),
  Medicine(
    name: 'Азитромицин',
    price: 70,
    imageUrl:
        "https://evropharm.ru/Storage/azitromicin-500-mg-N3-tabl-verteks.jpg",
  ),
  Medicine(
    name: 'Черника Форте',
    price: 90,
    imageUrl:
        "https://cdn.eapteka.ru/upload/offer_photo/209/604/resized/450_450_1_2a2eb8f6df8c079a54c210b8ae3db676.png?t=1727348871&_cvc=1760730070",
  ),
];

@Riverpod(keepAlive: true)
class MedicinesNotifier extends _$MedicinesNotifier {
  @override
  List<Medicine> build() {
    return _initialMedicines;
  }
}
