extension StringExtensions on String {
  String withoutExtension() {
    final dotIndex = lastIndexOf('.');
    if (dotIndex == -1) return this;
    return substring(0, dotIndex);
  }
}