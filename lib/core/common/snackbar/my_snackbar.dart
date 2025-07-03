import 'package:flutter/material.dart';

void showSnackbar({
  required String message,
  required BuildContext context,
  Color? color,
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color, duration: Duration(milliseconds: 600), behavior: SnackBarBehavior.floating,));
}
