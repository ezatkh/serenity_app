import 'package:flutter/cupertino.dart';

import 'base/api_service.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> checkNIF({
    required String nif,
    required BuildContext context,
  }) {
    return ApiRequest.get(
      'https://yourapi.com/auth/check-nif/$nif',
      context: context,
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    return ApiRequest.post(
      'https://yourapi.com/auth/login',
      {'email': email, 'password': password},
      context: context,
    );
  }
}
