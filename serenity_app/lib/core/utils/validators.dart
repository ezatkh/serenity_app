class ValidationHelper {
  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  static String? validateRequired(String? input, String fieldName) {
    if (input == null || input.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(email);
  }

}