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
          'https://ozerki.ru/_next/image/?url=https%3A%2F%2Fozerki.ru%2Fer-pics%2Fimages%2Fgoods%2F77719%2Fmain&w=768&q=90',
      description: 'Противовоспалительное средство',
      manufacturer: 'Синтез',
    ),
    Medicine(
      id: '3',
      name: 'Аспирин',
      price: 90,
      imageUrl:
          'https://evropharm.ru/Storage/Resized/w_480/aspirin-bajer-0-5-n20.jpg',
      description: 'Жаропонижающее, обезболивающее',
      manufacturer: 'Bayer',
    ),
    Medicine(
      id: '4',
      name: 'Азитромицин',
      price: 70,
      imageUrl:
          'https://evropharm.ru/Storage/azitromicin-500-mg-N3-tabl-verteks.jpg',
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
