import 'package:get_it/get_it.dart';

import '../../features/account/data/datasources/payment_methods_data_source.dart';
import '../../features/account/data/datasources/payment_methods_data_source_impl.dart';
import '../../features/account/data/datasources/profile_data_source.dart';
import '../../features/account/data/datasources/profile_data_source_impl.dart';
import '../../features/account/data/datasources/referral_data_source.dart';
import '../../features/account/data/datasources/referral_data_source_impl.dart';
import '../../features/account/data/datasources/wallet_data_source.dart';
import '../../features/account/data/datasources/wallet_data_source_impl.dart';
import '../../features/account/data/repositories/payment_methods_repository_impl.dart';
import '../../features/account/data/repositories/payment_preferences_repository_impl.dart';
import '../../features/account/data/repositories/profile_repository_impl.dart';
import '../../features/account/data/repositories/referral_repository_impl.dart';
import '../../features/account/data/repositories/wallet_repository_impl.dart';
import '../../features/account/domain/repositories/payment_methods_repository.dart';
import '../../features/account/domain/repositories/payment_preferences_repository.dart';
import '../../features/account/domain/repositories/profile_repository.dart';
import '../../features/account/domain/repositories/referral_repository.dart';
import '../../features/account/domain/repositories/wallet_repository.dart';
import '../../features/account/domain/usecases/payment_methods_usecases.dart';
import '../../features/account/domain/usecases/payment_preferences_usecases.dart';
import '../../features/account/domain/usecases/profile_usecases.dart';
import '../../features/account/domain/usecases/referral_usecases.dart';
import '../../features/account/domain/usecases/wallet_usecases.dart';
import '../../features/account/presentation/cubit/loyalty_history_cubit.dart';
import '../../features/account/presentation/cubit/payment_methods_cubit.dart';
import '../../features/account/presentation/cubit/payment_preferences_cubit.dart';
import '../../features/account/presentation/cubit/profile_cubit.dart';
import '../../features/account/presentation/cubit/referral_cubit.dart';
import '../../features/account/presentation/cubit/wallet_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/locations_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/locations_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_user.dart';
import '../../features/auth/domain/usecases/location_usecases.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/refresh_session_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/save_pending_avatar_usecase.dart';
import '../../features/auth/domain/usecases/social_login_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/locations_cubit.dart';
import '../../features/checkout/data/datasources/cart_remote_data_source.dart';
import '../../features/checkout/data/datasources/checkout_remote_data_source.dart';
import '../../features/checkout/data/repositories/cart_repository_impl.dart';
import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/checkout/domain/repositories/cart_repository.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/cart_usecases.dart';
import '../../features/checkout/domain/usecases/place_order.dart';
import '../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../features/customization/data/repositories/customization_repository_impl.dart';
import '../../features/customization/domain/repositories/customization_repository.dart';
import '../../features/customization/domain/usecases/customization_usecases.dart';
import '../../features/customization/presentation/cubit/customization_cubit.dart';
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
import '../../features/menu/domain/usecases/get_menu.dart';
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
import '../../features/promotions/data/datasources/promotions_remote_data_source.dart';
import '../../features/promotions/data/datasources/promotions_remote_data_source_impl.dart';
import '../../features/promotions/data/repositories/promotions_repository_impl.dart';
import '../../features/promotions/domain/repositories/promotions_repository.dart';
import '../../features/promotions/domain/usecases/get_home_slider.dart';
import '../../features/promotions/presentation/cubit/promotions_cubit.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../cubit/connectivity_cubit.dart';
import '../cubit/shell_cubit.dart';
import '../entities/connection_status.dart';
import '../security/credential_storage.dart';
import 'api_service.dart';
import 'local_storage_service.dart';
import 'location_service.dart';
import 'network_info_service.dart';
import 'secure_credential_storage.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Core Services ──────────────────────────────────────────────────────────

  final localStorage = LocalStorageService();
  await localStorage.init();
  sl.registerSingleton<LocalStorageService>(localStorage);

  final credentials = SecureCredentialStorage();
  await credentials.migrateFrom(localStorage);
  sl.registerSingleton<CredentialStorage>(credentials);

  sl.registerLazySingleton<ShellCubit>(() => ShellCubit());

  sl.registerLazySingleton<ApiService>(
    () => ApiService(sl<CredentialStorage>()),
  );
  sl.registerLazySingleton<LocationService>(() => LocationService(sl()));
  sl.registerLazySingleton<NetworkInfoService>(() => NetworkInfoServiceImpl());
  sl.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(sl<NetworkInfoService>()),
  );

  // ── Auth ────────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localStorage: sl<LocalStorageService>(),
      credentials: sl<CredentialStorage>(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => RefreshSessionUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => SavePendingAvatarUseCase(sl()));
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      refreshSessionUseCase: sl(),
      verifyEmailUseCase: sl(),
      resendVerificationUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      socialLoginUseCase: sl(),
      savePendingAvatarUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetStatesUseCase(sl()));
  sl.registerLazySingleton(() => GetCitiesUseCase(sl()));
  sl.registerFactory(() => LocationsCubit(getStates: sl(), getCities: sl()));

  // ── Menu ────────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMenu(sl()));

  sl.registerFactory(
    () => MenuCubit(
      getMenu: sl(),
      getProducts: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

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
    () => ProfileDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetLoyaltyPointsUseCase(sl()));
  sl.registerLazySingleton(() => GetLoyaltyHistoryUseCase(sl()));
  sl.registerFactory(() => LoyaltyHistoryCubit(sl()));
  sl.registerLazySingleton(() => UploadAvatarUseCase(sl()));
  sl.registerLazySingleton(() => ChangeEmailUseCase(sl()));
  sl.registerFactory(
    () => ProfileCubit(
      getProfile: sl(),
      updateProfile: sl(),
      getLoyaltyPoints: sl(),
      uploadAvatar: sl(),
      changeEmail: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  // ── Wallet ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<WalletDataSource>(
    () => WalletDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetWalletBalanceUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWalletPhoneUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletPackagesUseCase(sl()));
  sl.registerLazySingleton(() => BuyWalletPackageUseCase(sl()));
  sl.registerFactory(
    () => WalletCubit(
      getBalance: sl(),
      getTransactions: sl(),
      updatePhone: sl(),
      getPackages: sl(),
      buyPackage: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  // ── Payment Methods ─────────────────────────────────────────────────────────

  sl.registerLazySingleton<PaymentMethodsDataSource>(
    () => PaymentMethodsDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<PaymentMethodsRepository>(
    () => PaymentMethodsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetPaymentMethodsUseCase(sl()));
  sl.registerLazySingleton(() => AddCardUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCardUseCase(sl()));
  sl.registerFactory(
    () => PaymentMethodsCubit(
      getMethods: sl(),
      addCard: sl(),
      deleteCard: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );
  sl.registerLazySingleton<PaymentPreferencesRepository>(
    () => PaymentPreferencesRepositoryImpl(sl<LocalStorageService>()),
  );
  sl.registerLazySingleton(() => GetPaymentPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => SetDefaultPaymentMethodUseCase(sl()));
  sl.registerLazySingleton(() => SetWalletPhoneUseCase(sl()));
  sl.registerFactory(
    () => PaymentPreferencesCubit(
      getPreferences: sl(),
      setDefaultMethod: sl(),
      setWalletPhone: sl(),
      updateWalletPhone: sl(),
    ),
  );

  // ── Referral ─────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<ReferralDataSource>(
    () => ReferralDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReferralRepository>(
    () => ReferralRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetReferralUseCase(sl()));
  sl.registerLazySingleton(() => ApplyReferralUseCase(sl()));
  sl.registerFactory(
    () => ReferralCubit(
      getReferral: sl(),
      applyReferral: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  // ── Cart / Checkout ─────────────────────────────────────────────────────────

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl(), sl()));
  sl.registerFactory(
    () => CartCubit(
      getCart: sl(),
      addToCart: sl(),
      updateItem: sl(),
      removeItem: sl(),
      clearCart: sl(),
      placeOrder: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  sl.registerLazySingleton<CustomizationRepository>(
    () => CustomizationRepositoryImpl(sl<LocalStorageService>()),
  );
  sl.registerLazySingleton(() => GetSavedCustomizationUseCase(sl()));
  sl.registerLazySingleton(() => SaveCustomizationUseCase(sl()));
  sl.registerLazySingleton(() => ClearCustomizationUseCase(sl()));
  sl.registerLazySingleton(() => BuildSavedCartItemUseCase(sl()));
  sl.registerFactory(
    () => CustomizationCubit(
      getSaved: sl(),
      save: sl(),
      clear: sl(),
      buildCartItem: sl(),
    ),
  );

  // ── Orders ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<OrdersDataSource>(() => OrdersDataSourceImpl(sl()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderByIdUseCase(sl()));
  sl.registerFactory(
    () => OrdersCubit(
      sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  // ── Favorites ───────────────────────────────────────────────────────────────

  sl.registerLazySingleton<FavoritesDataSource>(
    () => FavoritesDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerFactory(
    () => FavoritesCubit(
      getFavorites: sl(),
      toggle: sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );

  // ── Settings ─────────────────────────────────────────────────────────────────

  final settingsLocal = SettingsLocalDataSource();
  await settingsLocal.init();
  sl.registerSingleton<SettingsLocalDataSource>(settingsLocal);

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl(), sl(), sl<CredentialStorage>()),
  );
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));
  sl.registerFactory(
    () => SettingsCubit(getSettings: sl(), updateSettings: sl()),
  );

  // ── Promotions ───────────────────────────────────────────────────────────────

  sl.registerLazySingleton<PromotionsRemoteDataSource>(
    () => PromotionsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PromotionsRepository>(
    () => PromotionsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetHomeSliderUseCase(sl()));
  sl.registerFactory(
    () => PromotionsCubit(
      sl(),
      onConnectionFailure: (f) => sl<ConnectivityCubit>().markOffline(
        ConnectionStatus.serverUnreachable,
      ),
    ),
  );
}
