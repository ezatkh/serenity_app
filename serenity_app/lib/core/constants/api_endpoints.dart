class ApiConstants {
  static const String baseUrl = 'https://sandbox.serenity-portugal.com/api/v1';

  static const String accountUrl = '$baseUrl/Account';


  static String getCasesUrl(String accountId) {
    return '$baseUrl/Account/$accountId/cases';
  }
}