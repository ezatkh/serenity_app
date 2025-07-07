import 'package:flutter/cupertino.dart';

import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> checkNIF({
    required String nif,
    required BuildContext context,
  }) {
    return ApiRequest.get(
      '${ApiConstants.searchByNif}$nif',
      context: context,
    );
  }
}
