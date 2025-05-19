import 'package:flutter/material.dart';
import 'package:tradeverse/view/login_screen.dart';
import 'package:tradeverse/view/signup_screen.dart';
import 'package:tradeverse/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Screens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        "/login":(context) => const LoginScreen(),
        "/signup":(context) => const SignupScreen()
      },
    );
  }
}