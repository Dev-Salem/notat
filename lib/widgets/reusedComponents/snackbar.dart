import 'package:flutter/material.dart';

class CustomSnackBar {
  final String message;
  final Duration duration;
  CustomSnackBar({required this.message, required this.duration});

  static show(BuildContext context, String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).cardColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Text(message)));
  }
}
