import 'package:flutter/cupertino.dart';

import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class ProfileApiService {
  static Future<Map<String, dynamic>> getAccountDetail({
    required String accountId,
    required BuildContext context,
  }) {
    return ApiRequest.get(
      '${ApiConstants.get_accountDetail}/$accountId',
      context: context,
    );
  }

  static Future<Map<String, dynamic>> updateAccountDetail({
    required String accountId,
    required Map<String, dynamic> body,
    required BuildContext context,
  }) {
    return ApiRequest.patch(
      '${ApiConstants.patch_accountDetail}/$accountId',
      body,
      context: context,
    );
  }
}
