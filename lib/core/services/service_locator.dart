import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/menu/data/datasources/category_remote_data_source.dart';
import '../../features/menu/data/datasources/category_remote_data_source_impl.dart';
import '../../features/menu/data/datasources/product_remote_data_source.dart';
import '../../features/menu/data/datasources/product_remote_data_source_impl.dart';
import '../../features/menu/data/repositories/category_repository_impl.dart';
import '../../features/menu/data/repositories/product_repository_impl.dart';
import '../../features/menu/domain/repositories/category_repository.dart';
import '../../features/menu/domain/repositories/product_repository.dart';
import '../../features/menu/domain/usecases/get_categories.dart';
import '../../features/menu/domain/usecases/get_products.dart';
import '../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_questions.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

import 'api_service.dart';
import 'local_storage_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // --- Core Services ---
  sl.registerLazySingleton<ApiService>(() => ApiService());

  final localDataSource = AppLocalDataSource();
  await localDataSource.init();
  sl.registerSingleton<AppLocalDataSource>(localDataSource);

  // --- Features ---

  // Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Cubit
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), registerUseCase: sl()));

  // Menu
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProducts(sl()));

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategories(sl()));

  sl.registerFactory(() => MenuCubit(getProducts: sl(), getCategories: sl()));

  // Onboarding
  // Data sources
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOnboardingQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));

  // Cubit
  sl.registerFactory(() => OnboardingCubit(sl(), sl()));
}
