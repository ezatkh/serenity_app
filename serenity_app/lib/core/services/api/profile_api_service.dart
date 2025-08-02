import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class ProfileApiService {
  static Future<Map<String, dynamic>> getAccountDetail({
    required String accountId,
  }) {
    return ApiRequest.get(
      '${ApiConstants.get_accountDetail}/$accountId',
    );
  }

  static Future<Map<String, dynamic>> updateAccountDetail({
    required String accountId,
    required Map<String, dynamic> body,
  }) {
    return ApiRequest.patch(
      '${ApiConstants.patch_accountDetail}/$accountId',
      body,
    );
  }
}
