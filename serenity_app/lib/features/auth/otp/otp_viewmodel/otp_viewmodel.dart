import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpController {
  final String emailOrPhone;
  final VoidCallback onVerified;

  final ValueNotifier<int> timer = ValueNotifier(60);
  final ValueNotifier<String?> error = ValueNotifier(null);
  Timer? _countdown;
  String? _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String normalizedPhone;

  OtpController({
    required this.emailOrPhone,
    required this.onVerified,
  }) {
    try {
      normalizedPhone = normalizeContact(emailOrPhone);
    } catch (e) {
      error.value = 'Invalid phone number';
    }
  }

  bool _isValidPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^\+\d{7,15}$');
    return phoneRegex.hasMatch(input.trim());
  }

  static String  normalizeContact(String input) {
    final trimmed = input.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isPortuguesePhone = RegExp(r'^\d{9}$');
    final isInternationalPhone = RegExp(r'^\+\d{7,15}$');

    if (emailRegex.hasMatch(trimmed)) return trimmed;
    if (isPortuguesePhone.hasMatch(trimmed)) return '+351$trimmed';
    if (isInternationalPhone.hasMatch(trimmed)) return trimmed;

    return trimmed;
  }

  void sendOtp() {
    error.value = null;

    if (!_isValidPhoneNumber(emailOrPhone)) {
      _setError('Invalid phone number. Please include country code (e.g. +351)');
      return;
    }

    _startTimer();

    _auth.verifyPhoneNumber(
      phoneNumber: normalizedPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
          onVerified();
        } catch (e) {
          _setError('Auto sign-in failed: $e');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _setError(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void resendOtp() {
    if (timer.value == 0) {
      sendOtp();
    }
  }

  Future<void> verifyOtp(String code) async {
    error.value = null;
    if (_verificationId == null) {
      _setError('No verification ID available. Please request OTP again.');
      return;
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      onVerified();
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    }
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

  void _setError(String? message) {
    error.value = message;
    debugPrint('OTP Error: $message');
  }

  void dispose() {
    _countdown?.cancel();
    timer.dispose();
    error.dispose();
  }
}
