import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/api/auth_api_service.dart';
import '../../../../core/services/cache/sharedPreferences.dart';
import '../../../../core/services/local/toast_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool isChecked = false;
  bool showTermsError = false;
  bool _isLoading = false;

  final TextEditingController nifController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool get isLoading => _isLoading;

  void setTermsAccepted(bool value) {
    isChecked = value;
    showTermsError = !value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? validateNIF(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "NIF is required";
    }
    // if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
    //   return "NIF must be exactly 9 digits";
    // }
    return null;
  }

  String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return "Mobile is required";
    }
    // add more checks if you want
    return null;
  }

  bool validateTerms(bool isChecked) {
    return isChecked;
  }

  static String normalizeContact(String input) {
    return input.trim();
  }



  Future<Map<String, dynamic>> handleNifCheck({
    required String nif,
    required String mobile,
    required BuildContext context,
  }) async {
    final response = await AuthApiService.checkNIF(nif: nif,mobile: mobile);

    final status = response['status'];
    final data = response['data'];

    if (status != 200) {
      print("data is ${data}");

      ToastService.show(
        message: response['error'] ?? 'Something went wrong',
        type: ToastType.error,
      );
    } else {
      final int total = data['total'] ?? 0;
      if (total == 0) {
        ToastService.show(
          message: 'No account found matching the provided information',
          type: ToastType.warning,
        );
      }
    }

    notifyListeners();
    return response;
  }
}
