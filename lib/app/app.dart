import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/splash/presentation/view/splash_view.dart';
import 'package:tradeverse/theme/theme_data.dart';
import 'package:tradeverse/view/dashboard.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trade Verse',
      theme: getApplicationTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        "/login":
            (context) => BlocProvider.value(
              value: serviceLocator<LoginViewModel>(),
              child: LoginView(),
            ),
        "/signup": (context) => SignupView(),
        "/dashboard": (context) => const Dashboard(),
      },
    );
  }
}
