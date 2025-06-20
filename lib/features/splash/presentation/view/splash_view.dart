import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  void _navigateAfterDelay(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensures the navigation code runs only after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay(context);
    });

    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/splash.json"),
      ),
    );
  }
}
