import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_user.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/checkout/data/datasources/cart_local_data_source.dart';
import '../../features/checkout/data/repositories/cart_repository_impl.dart';
import '../../features/checkout/domain/repositories/cart_repository.dart';
import '../../features/checkout/domain/usecases/cart_usecases.dart';
import '../../features/checkout/domain/usecases/place_order.dart';
import '../../features/checkout/presentation/cubit/cart_cubit.dart';

import '../../features/favorites/data/datasources/favorites_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/favorites_usecases.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';

import '../../features/menu/data/datasources/category_remote_data_source.dart';
import '../../features/menu/data/datasources/category_remote_data_source_impl.dart';
import '../../features/menu/data/datasources/product_remote_data_source.dart';
import '../../features/menu/data/datasources/product_remote_data_source_impl.dart';
import '../../features/menu/data/repositories/category_repository_impl.dart';
import '../../features/menu/data/repositories/product_repository_impl.dart';
import '../../features/menu/domain/repositories/category_repository.dart';
import '../../features/menu/domain/repositories/product_repository.dart';
import '../../features/menu/domain/usecases/get_categories.dart';
import '../../features/menu/domain/usecases/get_product_by_id.dart';
import '../../features/menu/domain/usecases/get_products.dart';
import '../../features/menu/presentation/cubit/menu_cubit.dart';

import '../../features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_questions.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

import '../../features/orders/data/datasources/orders_data_source.dart';
import '../../features/orders/data/datasources/orders_data_source_impl.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/orders_usecases.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

import '../../features/profile/data/datasources/profile_data_source.dart';
import '../../features/profile/data/datasources/profile_data_source_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

import 'api_service.dart';
import 'local_storage_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Core Services ──────────────────────────────────────────────────────────

  final localStorage = LocalStorageService();
  await localStorage.init();
  sl.registerSingleton<LocalStorageService>(localStorage);

  sl.registerLazySingleton<ApiService>(() => ApiService(sl<LocalStorageService>()));

  // ── Auth ────────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localStorage: sl<LocalStorageService>(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), registerUseCase: sl()));

  // ── Menu ────────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));

  sl.registerFactory(() => MenuCubit(getProducts: sl(), getCategories: sl()));

  // ── Onboarding ──────────────────────────────────────────────────────────────

  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => GetOnboardingQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));
  sl.registerFactory(() => OnboardingCubit(sl(), sl()));

  // ── Profile ─────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<ProfileDataSource>(
    () => ProfileDataSourceImpl(sl(), sl<LocalStorageService>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetLoyaltyPointsUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(
        getProfile: sl(),
        updateProfile: sl(),
        getLoyaltyPoints: sl(),
      ));

  // ── Cart / Checkout ─────────────────────────────────────────────────────────

  final cartLocal = CartLocalDataSource();
  await cartLocal.init();
  sl.registerSingleton<CartLocalDataSource>(cartLocal);

  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl()));
  sl.registerFactory(() => CartCubit(
        getCart: sl(),
        addToCart: sl(),
        updateItem: sl(),
        removeItem: sl(),
        clearCart: sl(),
        placeOrder: sl(),
      ));

  // ── Orders ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<OrdersDataSource>(() => OrdersDataSourceImpl(sl()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderByIdUseCase(sl()));
  sl.registerFactory(() => OrdersCubit(sl()));

  // ── Favorites ───────────────────────────────────────────────────────────────

  sl.registerLazySingleton<FavoritesDataSource>(
    () => FavoritesDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerFactory(() => FavoritesCubit(getFavorites: sl(), toggle: sl()));

  // ── Settings ─────────────────────────────────────────────────────────────────

  final settingsLocal = SettingsLocalDataSource();
  await settingsLocal.init();
  sl.registerSingleton<SettingsLocalDataSource>(settingsLocal);

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));
  sl.registerFactory(() => SettingsCubit(
        getSettings: sl(),
        updateSettings: sl(),
      ));
}
