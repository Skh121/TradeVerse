// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_view_model.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
// Dashboard Imports
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_view_model.dart';

// Goal Imports
import 'package:tradeverse/features/goal/presentation/view_model/goal_event.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';

// Payment Imports
import 'package:tradeverse/features/payment/presentation/view_model/payment_view_model.dart';

// Profile Imports
import 'package:tradeverse/features/profile/presentation/view_model/profile_view_model.dart';

// Security Imports
import 'package:tradeverse/features/security/presentation/view_model/security_view_model.dart';

// Auth/Login Imports for state listening and routing
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/navigation/presentation/view/app_shell.dart'; // Your AppShell
import 'package:tradeverse/features/splash/presentation/view/splash_view.dart'; // Your SplashView
import 'package:tradeverse/features/trade/presentation/view_model/trade_event.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_state.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_view_model.dart';
import 'package:tradeverse/theme/theme_data.dart'; // Your getApplicationTheme()

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your common app theme here
    final ThemeData appTheme =
        getApplicationTheme(); // Use your existing theme function

    return MultiBlocProvider(
      providers: [
        // Provide ALL your Blocs here at the root level of your App widget
        BlocProvider(create: (_) => serviceLocator<LoginViewModel>()),
        BlocProvider(
          create:
              (_) =>
                  serviceLocator<DashboardViewModel>()
                    ..add(FetchDashboardStats()),
        ),
        BlocProvider(
          create: (_) => serviceLocator<GoalViewModel>()..add(FetchGoals()),
        ),
        BlocProvider(create: (_) => serviceLocator<ProfileViewModel>()),
        BlocProvider(create: (_) => serviceLocator<SecurityViewModel>()),
        BlocProvider(
          create:
              (_) =>
                  serviceLocator<TradeViewModel>()..add(const FetchAllTrades()),
        ),
        BlocProvider(create: (_) => serviceLocator<ChatBloc>()),
        BlocProvider(
          create:
              (_) =>
                  serviceLocator<
                    PaymentViewModel
                  >(), // PaymentViewModel also provided here
        ),
        BlocProvider<NotificationViewModel>(
          create: (_) => serviceLocator<NotificationViewModel>(),
        ),
        BlocProvider<LogoutViewModel>(
          create: (_) => serviceLocator<LogoutViewModel>(),
        ),
      ],
      child: MultiBlocListener(
        // Use MultiBlocListener for cross-Bloc communication
        listeners: [
          BlocListener<TradeViewModel, TradeState>(
            listener: (context, state) {
              if (state is TradeOperationSuccess) {
                context.read<DashboardViewModel>().add(FetchDashboardStats());
                context.read<GoalViewModel>().add(FetchGoals());
              }
            },
          ),
          // BlocListener<ChatViewModel, ChatState>(
          //   listener: (context, state) {
          //     if (state is MessageSentSuccess ||
          //         state is ConversationFoundOrCreateSuccess) {
          //       context.read<ChatViewModel>().add(FetchConversations());
          //     }
          //   },
          // ),
          // Add other cross-Bloc listeners here if needed
        ],
        child: BlocBuilder<LoginViewModel, LoginState>(
          // Listen to LoginViewModel for routing
          builder: (context, loginState) {
            // This is where you decide what to show based on login status
            // The initial route will always be SplashView.
            // SplashView will then trigger a check in LoginViewModel.
            // Based on LoginViewModel's state, it will navigate to AppShell or LoginPage.

            // Define routes for the main MaterialApp
            final Map<String, WidgetBuilder> appRoutes = {
              '/':
                  (context) =>
                      const SplashView(), // Initial route is SplashView
              '/login': (context) => LoginView(), // Login page
              '/signup': (context) => SignupView(), // Signup page
              '/app_shell':
                  (context) => const AppShell(), // Authenticated main content
            };

            // Handle navigation based on LoginState
            // This logic is typically handled within the SplashView itself,
            // or by a dedicated Auth flow coordinator.
            // For simplicity, if SplashView is done, and state is success, navigate to AppShell
            // If SplashView is done, and state is not success, navigate to LoginPage.
            // This requires SplashView to pushReplacementNamed to either /login or /app_shell.

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Trade Verse',
              theme: appTheme,
              initialRoute: '/', // Start with SplashView
              routes: appRoutes,
            );
          },
        ),
      ),
    );
  }
}
