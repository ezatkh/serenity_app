import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class MedicalRecordsApiService {
  static Future<Map<String, dynamic>> getMedicalRecords({
    required String accountId,
  }) {
    final url = ApiConstants.getMedicalRecordsUrl(accountId);
    return ApiRequest.get(
      url,
    );
  }
}
