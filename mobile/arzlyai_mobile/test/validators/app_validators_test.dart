import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

void main() {
  test('topic validator rejects empty', () {
    expect(AppValidators.requiredNonEmpty(''), isNotNull);
    expect(AppValidators.requiredNonEmpty('  '), isNotNull);
    expect(AppValidators.requiredNonEmpty('AI agents'), isNull);
  });

  test('temperature clamp honors bounds', () {
    expect(AppValidators.clampTemperature(-1, 0, 1.5), 0);
    expect(AppValidators.clampTemperature(2, 0, 1.5), 1.5);
    expect(AppValidators.clampTemperature(0.7, 0, 1.5), 0.7);
  });
}
