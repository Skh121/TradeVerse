import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:tradeverse/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_register_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initApiService();
  _initAuthModule();
  _initHiveService();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initAuthModule() async {
  // --- Data Sources ---
  // Registers the remote data source that fetches data from the API.
  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // --- Repositories ---
  // Registers the repository that uses the remote data source.
  serviceLocator.registerFactory<UserRemoteRepository>(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // --- Use Cases ---
  // Registers the use case for user registration, depending on the remote repository.
  serviceLocator.registerFactory<AuthRegisterUsecase>(
    () => AuthRegisterUsecase(
      authRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  // Registers the use case for user login, also depending on the remote repository.
  serviceLocator.registerFactory<AuthLoginUsecase>(
    () => AuthLoginUsecase(
      authRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  // --- ViewModels ---
  // Registers the view models, which can now find their required use cases.
  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<AuthLoginUsecase>()),
  );
  
  serviceLocator.registerFactory<SignupViewModel>(
    () => SignupViewModel(serviceLocator<AuthRegisterUsecase>()),
  );
}