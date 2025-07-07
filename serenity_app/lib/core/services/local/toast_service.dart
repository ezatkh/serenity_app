import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../constants/app_colors.dart';

enum ToastType { success, error, warning, info }

class ToastService {
  static void show({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color bgColor;

    switch (type) {
      case ToastType.success:
        bgColor = AppColors.successColor;
        break;
      case ToastType.error:
        bgColor = AppColors.errorColor;
        break;
      case ToastType.warning:
        bgColor = AppColors.infoColor;
        break;
      case ToastType.info:
      default:
        bgColor = Colors.grey.shade800;
    }

    showToast(
      message,
      duration: duration,
      position: ToastPosition.bottom,
      backgroundColor: bgColor,
      radius: 8.0,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      dismissOtherToast: true,
    );
  }
}
