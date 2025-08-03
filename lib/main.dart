// lib/main.dart

import 'package:flutter/material.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/payment/presentation/view_model/deep_link_listener.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_view_model.dart';

import 'app/app.dart'; // Import your new App widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive service
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);

  // Initialize all other dependencies via service locator
  await initDependencies();

  // Initialize DeepLinkListener (can access PaymentViewModel from serviceLocator)
  final deepLinkListener = DeepLinkListener(
    paymentViewModel: serviceLocator<PaymentViewModel>(),
  );
  deepLinkListener.startListening();

  // Run the main application widget
  runApp(const App());
}
