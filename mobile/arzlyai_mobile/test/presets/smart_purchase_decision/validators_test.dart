import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

void main() {
  test('DynamicPresetForm_WhenCandidateSeedsExceedFive_RejectsInput', () {
    final seeds = List.generate(
      6,
      (index) => CandidateSeed(label: 'Product $index'),
    );
    expect(
      AppValidators.candidateSeeds(seeds, maximum: 5),
      'At most 5 candidates allowed',
    );
  });

  test('candidate seed validator rejects non-https urls', () {
    expect(
      AppValidators.candidateSeeds(
        const [CandidateSeed(label: 'A', url: 'http://example.com')],
      ),
      'URL must use HTTPS',
    );
    expect(
      AppValidators.candidateSeeds(
        const [CandidateSeed(label: 'A', url: 'https://example.com')],
      ),
      isNull,
    );
  });
}
