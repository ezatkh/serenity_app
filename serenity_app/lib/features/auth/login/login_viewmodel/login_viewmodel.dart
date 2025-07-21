  import 'package:flutter/material.dart';

import '../../../../core/services/api/auth_api_service.dart';
import '../../../../core/services/local/toast_service.dart';

  class LoginViewModel {
    bool _isTermsAccepted = false;

    bool get isTermsAccepted => _isTermsAccepted;

    void updateTermsAccepted(bool value) {
      _isTermsAccepted = value;
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
      final trimmed = value?.trim() ?? '';
      if (trimmed.isEmpty) {
        return "Email or phone is required";
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      final isPortuguesePhone = RegExp(r'^\d{9}$');
      final isInternationalPhone = RegExp(r'^\+\d{7,15}$');

      if (emailRegex.hasMatch(trimmed)) return null;
      if (isPortuguesePhone.hasMatch(trimmed)) return null;
      if (isInternationalPhone.hasMatch(trimmed)) return null;

      return "Enter a valid email or phone number";
    }

    Future<Map<String, dynamic>> handleNifCheck({
      required String nif,
      required BuildContext context,
    }) async {
      final response = await AuthApiService.checkNIF(nif: nif, context: context);

      final status = response['status'];
      final data = response['data'];

      if (status != 200) {
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
      } else {
        final int total = data['total'] ?? 0;
        if (total == 0) {
          ToastService.show(
            message: 'No account found for this NIF',
            type: ToastType.warning,
          );
        }
      }
      return response;
    }
  }
