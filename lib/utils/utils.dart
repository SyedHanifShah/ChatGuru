import 'package:flutter/material.dart';

class MyUtils {
  void showToast(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Authetication failed.'),
      ),
    );
  }
}
