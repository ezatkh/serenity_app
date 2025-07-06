class ApiConstants {
  static const String baseUrl = 'https://sandbox.serenity-portugal.com/api/v1';
  static const String searchByNif = '$baseUrl/Account?where[0][type]=equals&where[0][attribute]=nIF&where[0][value]=';
}