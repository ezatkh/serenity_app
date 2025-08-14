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

  static Future<Map<String, dynamic>> getMedicalFolders() {
    const url = ApiConstants.medicalFoldersUrl;
    return ApiRequest.get(
      url,
    );
  }

  static Future<Map<String, dynamic>> getAttachmentDetail({
    required String fileId,
  }) {

    final url = ApiConstants.getAttachmentDetailUrl(fileId);
    return ApiRequest.get(
      url,
    );
  }

  static Future<Map<String, dynamic>> postAttachment({
    required Map<String, dynamic> body,
  }) {
    const url = ApiConstants.attachmentUrl;
    return ApiRequest.post(
        url,
        body,
    );
  }

  static Future<Map<String, dynamic>> postMedicalRecord({
    required Map<String, dynamic> body,
  }) {
    const url = ApiConstants.medicalRecordUrl;
    return ApiRequest.post(
      url,
      body,
    );
  }
}