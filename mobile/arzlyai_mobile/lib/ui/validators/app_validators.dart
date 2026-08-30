import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';

class AppValidators {
  static String? requiredNonEmpty(String value) {
    if (value.trim().isEmpty) return 'Required';
    return null;
  }

  static String? nonNegativeDecimal(String value) {
    if (value.trim().isEmpty) return null;
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) return 'Enter a non-negative number';
    return null;
  }

  static String? httpsUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || uri.scheme != 'https') return 'URL must use HTTPS';
    return null;
  }

  static String? candidateSeeds(List<CandidateSeed> seeds, {int maximum = 5}) {
    if (seeds.length > maximum) {
      return 'At most $maximum candidates allowed';
    }
    for (final seed in seeds) {
      final error = httpsUrl(seed.url);
      if (error != null) return error;
    }
    return null;
  }

  static double clampTemperature(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
