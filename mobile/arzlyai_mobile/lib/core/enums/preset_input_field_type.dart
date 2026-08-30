enum PresetInputFieldType {
  text,
  multilineText,
  decimal,
  country,
  currency,
  candidateList,
  unknown;

  static PresetInputFieldType parse(String? value) {
    return switch (value) {
      'text' => PresetInputFieldType.text,
      'multilineText' => PresetInputFieldType.multilineText,
      'decimal' => PresetInputFieldType.decimal,
      'country' => PresetInputFieldType.country,
      'currency' => PresetInputFieldType.currency,
      'candidateList' => PresetInputFieldType.candidateList,
      _ => PresetInputFieldType.unknown,
    };
  }
}
