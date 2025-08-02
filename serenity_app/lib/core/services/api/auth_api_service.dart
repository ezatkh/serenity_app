import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> checkNIF({
    required String nif,
  }) {
    return ApiRequest.get(
      '${ApiConstants.get_searchByNif}$nif',
    );
  }
}
