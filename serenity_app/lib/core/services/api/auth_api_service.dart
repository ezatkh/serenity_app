import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> checkNIF({
    required String nif,
    required String mobile,

  }) {
    final queryParameters = {
      'where[0][type]': 'equals',
      'where[0][attribute]': 'nIF',
      'where[0][value]': nif,
    };
    // 'where[1][type]': 'equals',
    // 'where[1][attribute]': 'phoneNumber',
    // 'where[1][value]': mobile,

    final uri = Uri.parse(ApiConstants.accountUrl).replace(queryParameters: queryParameters);

    return ApiRequest.get(uri.toString());
  }
}
