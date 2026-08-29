class AppValidators {
  static String? requiredNonEmpty(String value) {
    if (value.trim().isEmpty) return 'Required';
    return null;
  }

  static double clampTemperature(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
