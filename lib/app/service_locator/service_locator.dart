import 'package:get_it/get_it.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:tradeverse/features/auth/data/repository/auth_local_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_register_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

final serviceLocator = GetIt.instance;
 
Future<void> initDependencies() async {
  _initAuthModule();
  _initHiveService();
}
 
Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}
 
Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );
 
  serviceLocator.registerFactory(
    () => AuthLocalRepository(
      authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
    ),
  );
 
  serviceLocator.registerFactory(
    () => AuthRegisterUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  );
 
  serviceLocator.registerFactory(
    () => AuthLoginUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  );
 
  serviceLocator.registerFactory<LoginViewModel>(() => LoginViewModel(
    serviceLocator<AuthLoginUsecase>()
  ));
  serviceLocator.registerFactory<SignupViewModel>(() => SignupViewModel(
    serviceLocator<AuthRegisterUsecase>()
  ));
}
 
 