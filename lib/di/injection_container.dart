import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';
import '../data/datasources/api/dadata/dadata_api_datasource.dart';
import '../data/datasources/api/medicine_api_datasource.dart';
import '../data/datasources/api/nominatim/nominatim_api_datasource.dart';
import '../data/datasources/api/openfda/openfda_api_datasource.dart';
import '../data/datasources/api/overpass/overpass_api_datasource.dart';
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
import '../data/repositories/address_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/favourites_repository_impl.dart';
import '../data/repositories/loyalty_repository_impl.dart';
import '../data/repositories/map_repository_impl.dart';
import '../data/repositories/medicine_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/pharmacy_repository_impl.dart';
import '../data/repositories/theme_repository_impl.dart';
import '../domain/interfaces/repositories/address_repository.dart';
import '../domain/interfaces/repositories/auth_repository.dart';
import '../domain/interfaces/repositories/cart_repository.dart';
import '../domain/interfaces/repositories/favourites_repository.dart';
import '../domain/interfaces/repositories/loyalty_repository.dart';
import '../domain/interfaces/repositories/map_repository.dart';
import '../domain/interfaces/repositories/medicine_repository.dart';
import '../domain/interfaces/repositories/order_repository.dart';
import '../domain/interfaces/repositories/pharmacy_repository.dart';
import '../domain/interfaces/repositories/theme_repository.dart';
import '../domain/usecases/address/refine_address_usecase.dart';
import '../domain/usecases/address/suggest_by_city_usecase.dart';
import '../domain/usecases/address/suggest_cities_usecase.dart';
import '../domain/usecases/address/suggest_full_address_usecase.dart';
import '../domain/usecases/address/suggest_streets_usecase.dart';
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
import '../domain/usecases/map/filter_pharmacies_usecase.dart';
import '../domain/usecases/map/geocode_city_usecase.dart';
import '../domain/usecases/map/get_pharmacies_by_radius_usecase.dart';
import '../domain/usecases/map/update_pharmacies_region_usecase.dart';
import '../domain/usecases/medicine/get_all_medicines_usecase.dart';
import '../domain/usecases/medicine/get_manufacturer_drugs_usecase.dart';
import '../domain/usecases/medicine/get_medicine_analogs_usecase.dart';
import '../domain/usecases/medicine/get_medicine_details_usecase.dart';
import '../domain/usecases/medicine/get_medicines_sorted_usecase.dart';
import '../domain/usecases/medicine/get_random_medicines_usecase.dart';
import '../domain/usecases/medicine/get_side_effects_usecase.dart';
import '../domain/usecases/medicine/search_medicines_api_usecase.dart';
import '../domain/usecases/medicine/search_medicines_usecase.dart';
import '../domain/usecases/order/create_order_usecase.dart';
import '../domain/usecases/order/get_orders_usecase.dart';
import '../domain/usecases/pharmacy/get_all_pharmacies_usecase.dart';
import '../domain/usecases/pharmacy/get_pharmacy_by_id_usecase.dart';
import '../domain/usecases/theme/get_theme_mode_usecase.dart';
import '../domain/usecases/theme/save_theme_mode_usecase.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  _registerDioClients();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
}

void _registerDioClients() {
  // Регистрируем Dio клиенты для каждого API
  getIt.registerLazySingleton<Dio>(
    () => DioClient.openFda().dio,
    instanceName: 'openFda',
  );
  getIt.registerLazySingleton<Dio>(
    () => DioClient.dadata().dio,
    instanceName: 'dadata',
  );
  getIt.registerLazySingleton<Dio>(
    () => DioClient.nominatim().dio,
    instanceName: 'nominatim',
  );
  getIt.registerLazySingleton<Dio>(
    () => DioClient.overpass().dio,
    instanceName: 'overpass',
  );
}

void _registerDataSources() {
  // Existing data sources
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

  // API Data Sources (Dio)

  // OpenFDA API
  getIt.registerLazySingleton<OpenFdaApiDataSource>(
    () => OpenFdaApiDataSourceImpl(dio: getIt(instanceName: 'openFda')),
  );

  // DaData API
  getIt.registerLazySingleton<DaDataApiDataSource>(
    () => DaDataApiDataSourceImpl(dio: getIt(instanceName: 'dadata')),
  );

  // Nominatim API (OpenStreetMap geocoding)
  getIt.registerLazySingleton<NominatimApiDataSource>(
    () => NominatimApiDataSourceImpl(dio: getIt(instanceName: 'nominatim')),
  );

  // Overpass API (OpenStreetMap pharmacies)
  getIt.registerLazySingleton<OverpassApiDataSource>(
    () => OverpassApiDataSourceImpl(dio: getIt(instanceName: 'overpass')),
  );
}

void _registerRepositories() {
  // Updated MedicineRepository with OpenFDA support
  getIt.registerLazySingleton<MedicineRepository>(
    () => MedicineRepositoryImpl(
      apiDataSource: getIt(),
      localDataSource: getIt(),
      openFdaDataSource: getIt(),
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

  // NEW: Address Repository (DaData)
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(dataSource: getIt()),
  );

  // NEW: Map Repository (Nominatim + Overpass)
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(
      nominatimApi: getIt(),
      overpassApi: getIt(),
    ),
  );
}

void _registerUseCases() {
  // Existing medicine use cases
  getIt.registerLazySingleton(() => GetAllMedicinesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchMedicinesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMedicinesSortedUseCase(getIt()));

  // NEW: OpenFDA medicine use cases
  getIt.registerLazySingleton(() => GetRandomMedicinesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchMedicinesApiUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMedicineDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMedicineAnalogsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSideEffectsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetManufacturerDrugsUseCase(getIt()));

  // Pharmacy use cases
  getIt.registerLazySingleton(() => GetAllPharmaciesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPharmacyByIdUseCase(getIt()));

  // Cart use cases
  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartTotalUseCase(getIt()));

  // Order use cases
  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton(
    () => CreateOrderUseCase(getIt(), getIt(), getIt()),
  );

  // Auth use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));

  // Loyalty use cases
  getIt.registerLazySingleton(() => GetLoyaltyStateUseCase(getIt()));
  getIt.registerLazySingleton(() => SpendPointsUseCase(getIt()));

  // Favourites use cases
  getIt.registerLazySingleton(() => GetFavouritesUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleFavouriteUseCase(getIt()));
  getIt.registerLazySingleton(() => IsFavouriteUseCase(getIt()));

  // Theme use cases
  getIt.registerLazySingleton(() => GetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveThemeModeUseCase(getIt()));

  // NEW: Address use cases (DaData)
  getIt.registerLazySingleton(() => SuggestCitiesUseCase(getIt()));
  getIt.registerLazySingleton(() => SuggestStreetsUseCase(getIt()));
  getIt.registerLazySingleton(() => SuggestFullAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => SuggestByCityUseCase(getIt()));
  getIt.registerLazySingleton(() => RefineAddressUseCase(getIt()));

  // NEW: Map use cases (Nominatim + Overpass)
  getIt.registerLazySingleton(() => GeocodeCityUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPharmaciesByRadiusUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdatePharmaciesRegionUseCase(getIt()));
  getIt.registerLazySingleton(() => FilterPharmaciesUseCase(getIt()));
}
