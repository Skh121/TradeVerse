import 'package:flutter/material.dart';
import 'package:tradeverse/app/app.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/core/network/hive_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();
  runApp(const App());
}
