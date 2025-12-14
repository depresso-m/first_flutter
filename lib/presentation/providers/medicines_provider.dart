import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/medicine.dart';
import '../../data/mappers/medicine_mapper.dart';
import '../../di/injection_container.dart';
import '../../domain/usecases/medicine/get_all_medicines_usecase.dart';
import '../../domain/usecases/medicine/get_medicine_analogs_usecase.dart';
import '../../domain/usecases/medicine/get_medicine_details_usecase.dart';
import '../../domain/usecases/medicine/get_random_medicines_usecase.dart';
import '../../domain/usecases/medicine/get_side_effects_usecase.dart';
import '../../domain/usecases/medicine/search_medicines_api_usecase.dart';
import '../../domain/usecases/medicine/search_medicines_usecase.dart';

// State providers for UI
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortByPriceProvider = StateProvider<bool>((ref) => false);
final useApiDataProvider = StateProvider<bool>((ref) => true);

// Use case providers
final getAllMedicinesUseCaseProvider = Provider<GetAllMedicinesUseCase>(
  (ref) => getIt<GetAllMedicinesUseCase>(),
);

final searchMedicinesUseCaseProvider = Provider<SearchMedicinesUseCase>(
  (ref) => getIt<SearchMedicinesUseCase>(),
);

final getRandomMedicinesUseCaseProvider = Provider<GetRandomMedicinesUseCase>(
  (ref) => getIt<GetRandomMedicinesUseCase>(),
);

final searchMedicinesApiUseCaseProvider = Provider<SearchMedicinesApiUseCase>(
  (ref) => getIt<SearchMedicinesApiUseCase>(),
);

final getMedicineDetailsUseCaseProvider = Provider<GetMedicineDetailsUseCase>(
  (ref) => getIt<GetMedicineDetailsUseCase>(),
);

final getMedicineAnalogsUseCaseProvider = Provider<GetMedicineAnalogsUseCase>(
  (ref) => getIt<GetMedicineAnalogsUseCase>(),
);

final getSideEffectsUseCaseProvider = Provider<GetSideEffectsUseCase>(
  (ref) => getIt<GetSideEffectsUseCase>(),
);

// Local medicines provider (existing data)
final medicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final useCase = ref.watch(getAllMedicinesUseCaseProvider);
  return await useCase.execute();
});

// Random medicines from OpenFDA API
final randomMedicinesProvider = FutureProvider.autoDispose<List<Medicine>>((ref) async {
  final useCase = ref.read(getRandomMedicinesUseCaseProvider);
  // Smaller skip value to avoid out of range errors
  final skip = Random().nextInt(100);
  try {
    final result = await useCase.execute(skip: skip, limit: 15);
    // ignore: avoid_print
    print('OpenFDA loaded ${result.length} medicines');
    return result;
  } catch (e) {
    // ignore: avoid_print
    print('OpenFDA provider error: $e');
    rethrow;
  }
});

// API search provider with debounce
final apiSearchQueryProvider = StateProvider<String>((ref) => '');

final apiSearchMedicinesProvider = FutureProvider.autoDispose<List<Medicine>>((ref) async {
  final query = ref.watch(apiSearchQueryProvider);
  
  if (query.trim().length < 2) {
    // Return random medicines when no search query
    return ref.watch(randomMedicinesProvider.future);
  }
  
  // Debounce: wait 300ms after last change
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Check if query changed during debounce
  if (ref.read(apiSearchQueryProvider) != query) {
    throw Exception('Cancelled');
  }
  
  final useCase = ref.watch(searchMedicinesApiUseCaseProvider);
  return await useCase.execute(query);
});

// Combined filtered medicines provider (supports both local and API)
final filteredMedicinesProvider = Provider<AsyncValue<List<Medicine>>>((ref) {
  final useApi = ref.watch(useApiDataProvider);
  
  if (useApi) {
    final apiResult = ref.watch(apiSearchMedicinesProvider);
    // If API fails, show error but allow switching to local
    return apiResult;
  }
  
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

// Medicine details provider
final medicineDetailsProvider = FutureProvider.autoDispose
    .family<MedicineDetails?, String>((ref, ndc) async {
  if (ndc.isEmpty) return null;
  
  final useCase = ref.watch(getMedicineDetailsUseCaseProvider);
  return await useCase.execute(ndc);
});

// Medicine analogs provider
final medicineAnalogsProvider = FutureProvider.autoDispose
    .family<List<Medicine>, String>((ref, activeIngredient) async {
  if (activeIngredient.isEmpty) return [];
  
  final useCase = ref.watch(getMedicineAnalogsUseCaseProvider);
  return await useCase.execute(activeIngredient);
});

// Side effects provider
final sideEffectsProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, brandName) async {
  if (brandName.isEmpty) return [];
  
  final useCase = ref.watch(getSideEffectsUseCaseProvider);
  return await useCase.execute(brandName);
});
