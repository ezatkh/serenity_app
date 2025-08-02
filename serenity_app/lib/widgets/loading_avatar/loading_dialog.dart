import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'avatar_screen.dart';

class LoadingDialog {
  static void show(BuildContext context) {

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: LoadingAvatar(),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
