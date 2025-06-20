import 'dart:async';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  final BuildContext context;

  SplashViewModel(this.context);

  void startTimer() {
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }
}
