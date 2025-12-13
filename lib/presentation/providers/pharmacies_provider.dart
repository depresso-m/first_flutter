import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/models/pharmacy.dart';
import '../../domain/usecases/pharmacy/get_all_pharmacies_usecase.dart';

final getAllPharmaciesUseCaseProvider = Provider<GetAllPharmaciesUseCase>(
  (ref) => getIt<GetAllPharmaciesUseCase>(),
);

final pharmaciesProvider = FutureProvider<List<Pharmacy>>((ref) async {
  final useCase = ref.watch(getAllPharmaciesUseCaseProvider);
  return await useCase.execute();
});
