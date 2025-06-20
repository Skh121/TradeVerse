import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeverse/features/splash/presentation/view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = SplashViewModel(context);
      viewModel.initSplash();
    });

    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/splash.json"),
      ),
    );
  }
}
