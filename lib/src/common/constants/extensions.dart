extension StringExtensions on String {
  String get initCapitalized {
    return this[0].toUpperCase() + substring(1);
  }
}
