import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  final brandColor = Color(0xFFFF575A);
  return ThemeData(
    fontFamily: "Roboto Regular",
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandColor,
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 13),
      ),
    ),
  );
}
