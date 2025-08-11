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

  static Future<Map<String, dynamic>> getMedicalRecordFile({
    required String fileId,
  }) {
    final url = ApiConstants.getMedicalReportUrl(fileId);
    return ApiRequest.getBytes(
      url,
    );
  }
}
