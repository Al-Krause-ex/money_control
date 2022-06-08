import 'package:flutter/material.dart';

class ShowHelper {
  static void showMessage(
    context, {
    required String title,
    required Duration duration,
    SnackBarAction? snackBarAction,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(title),
        action: snackBarAction,
      ),
    );
  }
}
