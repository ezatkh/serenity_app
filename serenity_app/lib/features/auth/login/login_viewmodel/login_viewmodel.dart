import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isTermsAccepted = false;

  bool get isTermsAccepted => _isTermsAccepted;

  void updateTermsAccepted(bool value) {
    _isTermsAccepted = value;
    notifyListeners();
  }

  String? validateNIF(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "NIF is required";
    }
    if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
      return "NIF must be exactly 9 digits";
    }
    return null;
  }

  String? validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email or phone is required";
    }

    final trimmed = value.trim();
    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed);
    final isPhone = RegExp(r'^\d{7,15}$').hasMatch(trimmed);

    if (!isEmail && !isPhone) {
      return "Enter a valid email or phone number";
    }
    return null;
  }
}
