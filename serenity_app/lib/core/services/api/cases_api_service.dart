import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class CasesApiService {
  static Future<Map<String, dynamic>> getCases({
    required String accountId,
  }) {
    final url = ApiConstants.getCasesUrl(accountId);
    return ApiRequest.get(
      url,
    );
  }
}
