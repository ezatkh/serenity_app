import 'dart:async';
import 'package:flutter/material.dart';

class OtpController {
  final String userId;
  final String deliveryMethod;
  final VoidCallback onVerified;

  final ValueNotifier<int> timer = ValueNotifier(60);
  Timer? _countdown;

  OtpController({
    required this.userId,
    required this.deliveryMethod,
    required this.onVerified,
  });

  void sendOtp() {
    // TODO: Call your API or Firebase to send OTP here, depending on deliveryMethod
    debugPrint('Sending OTP to $userId via $deliveryMethod');
    _startTimer();
  }

  void resendOtp() {
    sendOtp();
  }

  void verifyOtp(String code) {
    // TODO: Call your API or Firebase to verify OTP here
    debugPrint('Verifying OTP $code for $userId');
    Future.delayed(const Duration(seconds: 1), () {
      onVerified();
    });
  }

  void _startTimer() {
    timer.value = 60;
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer.value == 0) {
        t.cancel();
      } else {
        timer.value--;
      }
    });
  }

  void dispose() {
    _countdown?.cancel();
    timer.dispose();
  }
}
