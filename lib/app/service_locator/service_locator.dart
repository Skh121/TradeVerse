import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:tradeverse/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:tradeverse/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_register_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/logout_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/request_otp_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/reset_password_with_otp_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:tradeverse/features/chat/data/data_source/local_data_source/chat_local_data_source.dart';
import 'package:tradeverse/features/chat/data/data_source/remote_data_source/chat_remote_data_source.dart';
import 'package:tradeverse/features/chat/data/repository/chat_repository_impl.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';
import 'package:tradeverse/features/chat/domain/use_case/create_message_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/find_or_create_conversation_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_chat_users_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_conversations_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_messages_use_case.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/dashboard/data/data_source/local_data_source/dashboard_stats_local_data_source.dart';
import 'package:tradeverse/features/dashboard/data/data_source/remote_data_source/dashboard_stats_remote_data_source.dart';
import 'package:tradeverse/features/dashboard/data/repository/dashboard_stats_repository_impl.dart';
import 'package:tradeverse/features/dashboard/domain/repository/dashboard_stats_repository.dart';
import 'package:tradeverse/features/dashboard/domain/use_case/get_dashboard_stats_use_case.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:tradeverse/features/goal/data/data_source/local_data_source/goal_local_data_source.dart';
import 'package:tradeverse/features/goal/data/data_source/remote_data_source/goal_remote_data_source.dart';
import 'package:tradeverse/features/goal/data/repository/goal_repository_impl.dart';
import 'package:tradeverse/features/goal/domain/repository/goal_repository.dart';
import 'package:tradeverse/features/goal/domain/use_case/create_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/delete_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/get_goal_use_case.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:tradeverse/features/notification/data/data_source/local_data_source/notification_local_data_source.dart';
import 'package:tradeverse/features/notification/data/data_source/remote_data_source/notification_remote_data_source.dart';
import 'package:tradeverse/features/notification/data/repository/notification_repository_impl.dart';
import 'package:tradeverse/features/notification/domain/repository/notification_repository.dart';
import 'package:tradeverse/features/notification/domain/use_case/get_notification_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/listen_for_notifications_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/mark_all_as_read_use_case.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:tradeverse/features/payment/data/data_source/local_data_source/payment_local_data_source.dart';
import 'package:tradeverse/features/payment/data/data_source/remote_data_source/payment_remote_data_source.dart';
import 'package:tradeverse/features/payment/data/repository/payment_repository_impl.dart';
import 'package:tradeverse/features/payment/domain/repository/payment_repository.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';
import 'package:tradeverse/features/payment/domain/use_case/get_plans_use_case.dart';
import 'package:tradeverse/features/payment/domain/use_case/verify_payment_use_case.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_view_model.dart';
import 'package:tradeverse/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:tradeverse/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:tradeverse/features/profile/data/repository/profile_repository_impl.dart';
import 'package:tradeverse/features/profile/domain/repository/profile_repository.dart';
import 'package:tradeverse/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:tradeverse/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tradeverse/features/security/data/data_source/remote_data_source/security_remote_data_source.dart';
import 'package:tradeverse/features/security/data/data_source/security_data_source.dart';
import 'package:tradeverse/features/security/data/repository/security_repository_impl.dart';
import 'package:tradeverse/features/security/domain/repository/security_repository.dart';
import 'package:tradeverse/features/security/domain/use_case/change_password_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/delete_account_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/export_data_use_case.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_view_model.dart';
import 'package:tradeverse/features/trade/data/data_source/local_data_source/trade_local_data_source.dart';
import 'package:tradeverse/features/trade/data/data_source/remote_data_source/trade_remote_data_source.dart';
import 'package:tradeverse/features/trade/data/repository/trade_repository_impl.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';
import 'package:tradeverse/features/trade/domain/use_case/create_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/delete_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_all_trades_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_trade_by_id_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/update_trade_use_case.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initApiService();
  _initAuthModule();
  _initHiveService();
  _init();
  _initPaymentModule();
  _initDashboardStatsModule();
  _initGoalModule();
  _initProfileModule();
  _initSecurityModule();
  _initTradeModule();
  _initChatModule();
  _initSocketService();
  _initNotificationModule();
}

Future<void> _initHiveService() async {
  if (!serviceLocator.isRegistered<HiveService>()) {
    serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  }
}

Future<void> _init() async {
  serviceLocator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  serviceLocator.registerLazySingleton<INetworkInfo>(() => NetworkInfoImpl());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initAuthModule() async {
  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory<AuthLocalDataSource>(
    () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
      localDataSource: serviceLocator<AuthLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
      secureStorage: serviceLocator<SecureStorageService>(),
      socketService: serviceLocator<SocketService>(),
      // hiveService: serviceLocator<HiveService>(),
    ),
  );

  serviceLocator.registerFactory<AuthRegisterUsecase>(
    () =>
        AuthRegisterUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<AuthLoginUsecase>(
    () => AuthLoginUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<RequestOtpUsecase>(
    () => RequestOtpUsecase(repository: serviceLocator<IAuthRepository>()),
  );
  serviceLocator.registerFactory<ResetPasswordWithOtpUsecase>(
    () => ResetPasswordWithOtpUsecase(
      repository: serviceLocator<IAuthRepository>(),
    ),
  );
  serviceLocator.registerFactory<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(repository: serviceLocator<IAuthRepository>()),
  );
  serviceLocator.registerFactory<LogoutUseCase>(
    () => LogoutUseCase(repository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<AuthLoginUsecase>()),
  );

  serviceLocator.registerFactory<SignupViewModel>(
    () => SignupViewModel(serviceLocator<AuthRegisterUsecase>()),
  );
  serviceLocator.registerFactory<LogoutViewModel>(
    () => LogoutViewModel(logoutUseCase: serviceLocator<LogoutUseCase>()),
  );

  serviceLocator.registerFactory<ForgotPasswordViewModel>(
    () => ForgotPasswordViewModel(
      requestOtpUsecase: serviceLocator<RequestOtpUsecase>(),
      verifyOtpUsecase: serviceLocator<VerifyOtpUsecase>(),
      resetPasswordWithOtpUsecase:
          serviceLocator<ResetPasswordWithOtpUsecase>(),
    ),
  );
}

void _initPaymentModule() {
  // Data Sources
  serviceLocator.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSource(serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSource(serviceLocator<HiveService>().paymentBox),
  );

  // Repository (implements IPaymentRepository)
  serviceLocator.registerLazySingleton<IPaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: serviceLocator<PaymentRemoteDataSource>(),
      localDataSource: serviceLocator<PaymentLocalDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory<GetPlansUseCase>(
    () => GetPlansUseCase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );

  serviceLocator.registerFactory<CheckoutUseCase>(
    () => CheckoutUseCase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );

  serviceLocator.registerFactory<VerifyPaymentUseCase>(
    () => VerifyPaymentUseCase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );

  // ViewModel
  serviceLocator.registerFactory<PaymentViewModel>(
    () => PaymentViewModel(
      getPlansUseCase: serviceLocator<GetPlansUseCase>(),
      checkoutUseCase: serviceLocator<CheckoutUseCase>(),
      verifyPaymentUseCase: serviceLocator<VerifyPaymentUseCase>(),
    ),
  );
}

// ... existing initDependencies, _initHiveService, _init, _initApiService, _initAuthModule, _initPaymentModule ...

Future<void> _initDashboardStatsModule() async {
  // --- Data Sources ---
  serviceLocator.registerLazySingleton<DashboardStatsRemoteDataSource>(
    () => DashboardStatsRemoteDataSource(serviceLocator<ApiService>()),
  );

  // Register the new LOCAL data source with its concrete type
  serviceLocator.registerLazySingleton<DashboardStatsLocalDataSource>(
    () => DashboardStatsLocalDataSource(serviceLocator<HiveService>()),
  );

  // --- REPOSITORY ---
  // Register the unified repository as the IDashboardStatsRepository interface.
  // It now receives its three required dependencies.
  serviceLocator.registerLazySingleton<IDashboardStatsRepository>(
    () => DashboardStatsRepositoryImpl(
      // Provide the concrete implementations which GetIt can find
      remoteDataSource: serviceLocator<DashboardStatsRemoteDataSource>(),
      localDataSource: serviceLocator<DashboardStatsLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );
  // --- Use Cases ---
  serviceLocator.registerFactory<GetDashboardStatsUseCase>(
    () => GetDashboardStatsUseCase(
      repository: serviceLocator<IDashboardStatsRepository>(),
    ),
  );

  // --- ViewModels ---
  serviceLocator.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(
      serviceLocator<GetDashboardStatsUseCase>(),
      serviceLocator<HiveService>(),
    ),
  );
}

Future<void> _initGoalModule() async {
  // Data Source
  serviceLocator.registerLazySingleton<GoalRemoteDataSource>(
    () => GoalRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<GoalLocalDataSource>(
    () => GoalLocalDataSource(serviceLocator<HiveService>()),
  );

  // --- REPOSITORY ---
  serviceLocator.registerLazySingleton<IGoalRepository>(
    () => GoalRepositoryImpl(
      remoteDataSource: serviceLocator<GoalRemoteDataSource>(),
      localDataSource: serviceLocator<GoalLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );

  // Use Cases (Register all CRUD use cases, excluding UpdateGoal)
  serviceLocator.registerLazySingleton<CreateGoalUseCase>(
    () => CreateGoalUseCase(serviceLocator<IGoalRepository>()),
  );
  serviceLocator.registerLazySingleton<GetGoalsUseCase>(
    () => GetGoalsUseCase(serviceLocator<IGoalRepository>()),
  );
  serviceLocator.registerLazySingleton<DeleteGoalUseCase>(
    () => DeleteGoalUseCase(serviceLocator<IGoalRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory<GoalViewModel>(
    () => GoalViewModel(
      createGoal: serviceLocator<CreateGoalUseCase>(),
      getGoals: serviceLocator<GetGoalsUseCase>(),
      deleteGoal: serviceLocator<DeleteGoalUseCase>(),
    ),
  );
}

Future<void> _initProfileModule() async {
  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(serviceLocator<HiveService>()),
  );

  // --- REPOSITORY ---
  serviceLocator.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: serviceLocator<ProfileRemoteDataSource>(),
      localDataSource: serviceLocator<ProfileLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(
      getProfile: serviceLocator<GetProfileUseCase>(),
      updateProfile: serviceLocator<UpdateProfileUseCase>(),
    ),
  );
}

Future<void> _initSecurityModule() async {
  // Data Source
  serviceLocator.registerLazySingleton<ISecurityDataSource>(
    () => SecurityRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<ISecurityRepository>(
    () => SecurityRepositoryImpl(
      remoteDataSource: serviceLocator<ISecurityDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<ChangePassword>(
    () => ChangePassword(serviceLocator<ISecurityRepository>()),
  );
  serviceLocator.registerLazySingleton<DeleteAccount>(
    () => DeleteAccount(serviceLocator<ISecurityRepository>()),
  );
  serviceLocator.registerLazySingleton<ExportData>(
    () => ExportData(serviceLocator<ISecurityRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory<SecurityViewModel>(
    () => SecurityViewModel(
      changePassword: serviceLocator<ChangePassword>(),
      deleteAccount: serviceLocator<DeleteAccount>(),
      exportData: serviceLocator<ExportData>(),
    ),
  );
}

Future<void> _initTradeModule() async {
  // Data Source
  serviceLocator.registerLazySingleton<TradeRemoteDataSource>(
    () => TradeRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<TradeLocalDataSource>(
    () => TradeLocalDataSource(serviceLocator<HiveService>()),
  );

  // --- REPOSITORY ---
  serviceLocator.registerLazySingleton<ITradeRepository>(
    () => TradeRepositoryImpl(
      remoteDataSource: serviceLocator<TradeRemoteDataSource>(),
      localDataSource: serviceLocator<TradeLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<CreateTradeUseCase>(
    () => CreateTradeUseCase(serviceLocator<ITradeRepository>()),
  );
  serviceLocator.registerLazySingleton<GetAllTradesUseCase>(
    () => GetAllTradesUseCase(serviceLocator<ITradeRepository>()),
  );
  serviceLocator.registerLazySingleton<GetTradeByIdUseCase>(
    () => GetTradeByIdUseCase(serviceLocator<ITradeRepository>()),
  );
  serviceLocator.registerLazySingleton<UpdateTradeUseCase>(
    () => UpdateTradeUseCase(serviceLocator<ITradeRepository>()),
  );
  serviceLocator.registerLazySingleton<DeleteTradeUseCase>(
    () => DeleteTradeUseCase(serviceLocator<ITradeRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory<TradeViewModel>(
    () => TradeViewModel(
      createTrade: serviceLocator<CreateTradeUseCase>(),
      getAllTrades: serviceLocator<GetAllTradesUseCase>(),
      getTradeById: serviceLocator<GetTradeByIdUseCase>(),
      updateTrade: serviceLocator<UpdateTradeUseCase>(),
      deleteTrade: serviceLocator<DeleteTradeUseCase>(),
    ),
  );
}

Future<void> _initChatModule() async {
  // Data Source
  serviceLocator.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      socketService: serviceLocator<SocketService>(),
    ),
  );

  serviceLocator.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: serviceLocator<ChatRemoteDataSource>(),
      localDataSource: serviceLocator<ChatLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetConversationsUseCase>(
    () => GetConversationsUseCase(serviceLocator<IChatRepository>()),
  );
  serviceLocator.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(serviceLocator<IChatRepository>()),
  );
  serviceLocator.registerLazySingleton<CreateMessageUseCase>(
    () => CreateMessageUseCase(serviceLocator<IChatRepository>()),
  );
  serviceLocator.registerLazySingleton<FindOrCreateConversationUseCase>(
    () => FindOrCreateConversationUseCase(serviceLocator<IChatRepository>()),
  );
  serviceLocator.registerLazySingleton<GetChatUsersUseCase>(
    () => GetChatUsersUseCase(serviceLocator<IChatRepository>()),
  );

  // ViewModel (ChatBloc)
  serviceLocator.registerFactory<ChatBloc>(
    // Renamed to ChatBloc for consistency
    () => ChatBloc(
      getConversations: serviceLocator<GetConversationsUseCase>(),
      getMessages: serviceLocator<GetMessagesUseCase>(),
      createMessage: serviceLocator<CreateMessageUseCase>(),
      findOrCreateConversation:
          serviceLocator<FindOrCreateConversationUseCase>(),
      getChatUsers: serviceLocator<GetChatUsersUseCase>(),
      socketService:
          serviceLocator<SocketService>(), // Inject SocketService directly
    ),
  );
}

Future<void> _initSocketService() async {
  // Register IO.Socket instance
  serviceLocator.registerLazySingleton<IO.Socket>(
    () => IO.io(ApiEndpoints.serverAddress, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    }),
  );

  // Register SocketService
  serviceLocator.registerLazySingleton<SocketService>(
    () => SocketServiceImpl(
      serviceLocator<IO.Socket>(),
      serviceLocator<SecureStorageService>(), // Pass SecureStorageService
    ),
  );
}

Future<void> _initNotificationModule() async {
  // --- Data Sources ---
  // The remote data source depends on ApiService and the shared SocketService.
  serviceLocator.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      socketService: serviceLocator<SocketService>(),
    ),
  );

  serviceLocator.registerLazySingleton<NotificationLocalDataSource>(
    () =>
        NotificationLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<INotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: serviceLocator<NotificationRemoteDataSource>(),
      localDataSource: serviceLocator<NotificationLocalDataSource>(),
      networkInfo: serviceLocator<INetworkInfo>(),
    ),
  );

  // --- Use Cases ---
  // Each use case depends on the INotificationRepository.
  serviceLocator.registerFactory<GetNotificationUseCase>(
    () => GetNotificationUseCase(serviceLocator<INotificationRepository>()),
  );

  serviceLocator.registerFactory<MarkAllAsReadUseCase>(
    () => MarkAllAsReadUseCase(serviceLocator<INotificationRepository>()),
  );

  serviceLocator.registerFactory<ListenForNotificationsUseCase>(
    () => ListenForNotificationsUseCase(
      serviceLocator<INotificationRepository>(),
    ),
  );

  // --- BLoC (ViewModel) ---
  // The BLoC depends on all the feature's use cases.
  serviceLocator.registerFactory<NotificationViewModel>(
    () => NotificationViewModel(
      getNotifications: serviceLocator<GetNotificationUseCase>(),
      markAllAsRead: serviceLocator<MarkAllAsReadUseCase>(),
      listenForNotifications: serviceLocator<ListenForNotificationsUseCase>(),
    ),
  );
}
