import '../../../core/models/medicine.dart';

abstract class MedicineApiDataSource {
  Future<List<Medicine>> getAllMedicines();
  Future<Medicine?> getMedicineById(String id);
}

class MedicineApiDataSourceImpl implements MedicineApiDataSource {
  static final List<Medicine> _mockMedicines = [
    Medicine(
      id: '1',
      name: 'Парацетамол',
      price: 120,
      imageUrl:
          'https://cdn.eapteka.ru/upload/offer_photo/234/898/1_7e5109f0fb5a68c6dc68fd151df84d1a.png?t=1634213074&_cvc=1760108554',
      description: 'Жаропонижающее и обезболивающее средство',
      manufacturer: 'Фармстандарт',
    ),
    Medicine(
      id: '2',
      name: 'Ибупрофен',
      price: 150,
      imageUrl:
          'https://images.apteka.ru/original_eff4c8e9-4bee-4fac-89f8-d4ad142c0d24.png',
      description: 'Противовоспалительное средство',
      manufacturer: 'Синтез',
    ),
    Medicine(
      id: '3',
      name: 'Аспирин',
      price: 90,
      imageUrl:
          'https://cdn.eapteka.ru/upload/offer_photo/515/196/resized/230_230_1_e398cec94feead85b168c69c464b2cfb.png?t=1649777511&_cvc=1765262398',
      description: 'Жаропонижающее, обезболивающее',
      manufacturer: 'Bayer',
    ),
    Medicine(
      id: '4',
      name: 'Азитромицин',
      price: 70,
      imageUrl:
          'https://cdn.stolichki.ru/s/drugs/large/51/51391.jpg',
      description: 'Антибиотик широкого спектра действия',
      manufacturer: 'Вертекс',
    ),
    Medicine(
      id: '5',
      name: 'Черника Форте',
      price: 90,
      imageUrl:
          'https://cdn.eapteka.ru/upload/offer_photo/209/604/resized/450_450_1_2a2eb8f6df8c079a54c210b8ae3db676.png?t=1727348871&_cvc=1760730070',
      description: 'Витамины для глаз',
      manufacturer: 'Эвалар',
    ),
  ];

  @override
  Future<List<Medicine>> getAllMedicines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_mockMedicines);
  }

  @override
  Future<Medicine?> getMedicineById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _mockMedicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
