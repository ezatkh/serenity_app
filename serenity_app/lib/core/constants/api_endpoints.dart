class ApiConstants {
  static const String baseUrl = 'https://sandbox.serenity-portugal.com/api/v1';

  static const String get_searchByNif = '$baseUrl/Account?where[0][type]=equals&where[0][attribute]=nIF&where[0][value]=';

  static const String get_accountDetail = '$baseUrl/Account';

  static const String patch_accountDetail = '$baseUrl/Account';

  static String getCasesUrl(String accountId) {
    return '$baseUrl/Account/$accountId/cases';
  }
}