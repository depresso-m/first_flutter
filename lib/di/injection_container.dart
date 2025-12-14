import 'package:get_it/get_it.dart';

import '../data/datasources/api/medicine_api_datasource.dart';
import '../data/datasources/api/pharmacy_api_datasource.dart';
import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/local/cart_local_datasource.dart';
import '../data/datasources/local/drift/cart_drift_datasource.dart';
import '../data/datasources/local/drift/database.dart';
import '../data/datasources/local/favourites_local_datasource.dart';
import '../data/datasources/local/loyalty_local_datasource.dart';
import '../data/datasources/local/medicine_local_datasource.dart';
import '../data/datasources/local/order_local_datasource.dart';
import '../data/datasources/local/pharmacy_local_datasource.dart';
import '../data/datasources/local/secure_storage/secure_storage_datasource.dart';
import '../data/datasources/local/shared_prefs/shared_prefs_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/favourites_repository_impl.dart';
import '../data/repositories/loyalty_repository_impl.dart';
import '../data/repositories/medicine_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/pharmacy_repository_impl.dart';
import '../data/repositories/theme_repository_impl.dart';
import '../domain/interfaces/repositories/auth_repository.dart';
import '../domain/interfaces/repositories/cart_repository.dart';
import '../domain/interfaces/repositories/favourites_repository.dart';
import '../domain/interfaces/repositories/loyalty_repository.dart';
import '../domain/interfaces/repositories/medicine_repository.dart';
import '../domain/interfaces/repositories/order_repository.dart';
import '../domain/interfaces/repositories/pharmacy_repository.dart';
import '../domain/interfaces/repositories/theme_repository.dart';
import '../domain/usecases/auth/get_current_user_usecase.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/register_usecase.dart';
import '../domain/usecases/auth/update_profile_usecase.dart';
import '../domain/usecases/cart/add_to_cart_usecase.dart';
import '../domain/usecases/cart/clear_cart_usecase.dart';
import '../domain/usecases/cart/get_cart_items_usecase.dart';
import '../domain/usecases/cart/get_cart_total_usecase.dart';
import '../domain/usecases/cart/update_cart_item_usecase.dart';
import '../domain/usecases/favourites/get_favourites_usecase.dart';
import '../domain/usecases/favourites/is_favourite_usecase.dart';
import '../domain/usecases/favourites/toggle_favourite_usecase.dart';
import '../domain/usecases/loyalty/get_loyalty_state_usecase.dart';
import '../domain/usecases/loyalty/spend_points_usecase.dart';
import '../domain/usecases/medicine/get_all_medicines_usecase.dart';
import '../domain/usecases/medicine/get_medicines_sorted_usecase.dart';
import '../domain/usecases/medicine/search_medicines_usecase.dart';
import '../domain/usecases/order/create_order_usecase.dart';
import '../domain/usecases/order/get_orders_usecase.dart';
import '../domain/usecases/pharmacy/get_all_pharmacies_usecase.dart';
import '../domain/usecases/pharmacy/get_pharmacy_by_id_usecase.dart';
import '../domain/usecases/theme/get_theme_mode_usecase.dart';
import '../domain/usecases/theme/save_theme_mode_usecase.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
}

void _registerDataSources() {
  getIt.registerLazySingleton<MedicineApiDataSource>(
    () => MedicineApiDataSourceImpl(),
  );
  getIt.registerLazySingleton<MedicineLocalDataSource>(
    () => MedicineLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<PharmacyApiDataSource>(
    () => PharmacyApiDataSourceImpl(),
  );
  getIt.registerLazySingleton<PharmacyLocalDataSource>(
    () => PharmacyLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<SharedPrefsDataSource>(
    () => SharedPrefsDataSourceImpl(),
  );

  getIt.registerLazySingleton<SecureStorageDataSource>(
    () => SecureStorageDataSourceImpl(),
  );

  getIt.registerLazySingleton<AppDatabase>(
    () => AppDatabase(),
  );

  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartDriftDataSourceImpl(database: getIt()),
  );

  getIt.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt()),
  );

  getIt.registerLazySingleton<LoyaltyLocalDataSource>(
    () => LoyaltyLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<FavouritesLocalDataSource>(
    () => FavouritesLocalDataSourceImpl(),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<MedicineRepository>(
    () => MedicineRepositoryImpl(
      apiDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<PharmacyRepository>(
    () => PharmacyRepositoryImpl(
      apiDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<LoyaltyRepository>(
    () => LoyaltyRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<FavouritesRepository>(
    () => FavouritesRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(dataSource: getIt()),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton(() => GetAllMedicinesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchMedicinesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMedicinesSortedUseCase(getIt()));

  getIt.registerLazySingleton(() => GetAllPharmaciesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPharmacyByIdUseCase(getIt()));

  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartTotalUseCase(getIt()));

  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton(
    () => CreateOrderUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));

  getIt.registerLazySingleton(() => GetLoyaltyStateUseCase(getIt()));
  getIt.registerLazySingleton(() => SpendPointsUseCase(getIt()));

  getIt.registerLazySingleton(() => GetFavouritesUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleFavouriteUseCase(getIt()));
  getIt.registerLazySingleton(() => IsFavouriteUseCase(getIt()));

  getIt.registerLazySingleton(() => GetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveThemeModeUseCase(getIt()));
}
