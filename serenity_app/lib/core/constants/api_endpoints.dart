class ApiConstants {
  static const String baseUrl = 'https://sandbox.serenity-portugal.com/api/v1';

  static const String accountUrl = '$baseUrl/Account';

  static const String medicalFoldersUrl = '$baseUrl/PMR';

  static const String medicalRecordUrl = '$baseUrl/pMRFile';

  static const String attachmentUrl = '$baseUrl/Attachment';


  static String getCasesUrl(String accountId) {
    return '$baseUrl/Account/$accountId/cases';
  }

  static String getMedicalRecordsUrl(String accountId) {
    return '$baseUrl/Account/$accountId/pMRFiles';
  }

  static String getMedicalReportUrl(String fileId) {
    return '$baseUrl/Attachment/file/$fileId';
  }

  static String getAppointmentsUrl(String accountId) {
    return '$baseUrl/Account/$accountId/meetings';
  }

  static String getAttachmentDetailUrl(String fileId) {
    return '$baseUrl/Attachment/$fileId';
  }
}