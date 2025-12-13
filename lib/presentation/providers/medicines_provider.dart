import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/models/medicine.dart';
import '../../domain/usecases/medicine/get_all_medicines_usecase.dart';
import '../../domain/usecases/medicine/search_medicines_usecase.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final sortByPriceProvider = StateProvider<bool>((ref) => false);

final getAllMedicinesUseCaseProvider = Provider<GetAllMedicinesUseCase>(
  (ref) => getIt<GetAllMedicinesUseCase>(),
);

final searchMedicinesUseCaseProvider = Provider<SearchMedicinesUseCase>(
  (ref) => getIt<SearchMedicinesUseCase>(),
);

final medicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final useCase = ref.watch(getAllMedicinesUseCaseProvider);
  return await useCase.execute();
});

final filteredMedicinesProvider = Provider<AsyncValue<List<Medicine>>>((ref) {
  final medicinesAsync = ref.watch(medicinesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final sortByPrice = ref.watch(sortByPriceProvider);

  return medicinesAsync.whenData((medicines) {
    var filtered = medicines.toList();

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((m) => m.matchesQuery(searchQuery)).toList();
    }

    if (sortByPrice) {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    }

    return filtered;
  });
});
