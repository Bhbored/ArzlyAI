enum PresetInputFieldType {
  text,
  multilineText,
  decimal,
  country,
  currency,
  candidateList,
  selectCards,
  select,
  date,
  email,
  unknown;

  static PresetInputFieldType parse(String? value) {
    return switch (value) {
      'text' => PresetInputFieldType.text,
      'multilineText' => PresetInputFieldType.multilineText,
      'decimal' => PresetInputFieldType.decimal,
      'country' => PresetInputFieldType.country,
      'currency' => PresetInputFieldType.currency,
      'candidateList' => PresetInputFieldType.candidateList,
      'selectCards' => PresetInputFieldType.selectCards,
      'select' => PresetInputFieldType.select,
      'date' => PresetInputFieldType.date,
      'email' => PresetInputFieldType.email,
      _ => PresetInputFieldType.unknown,
    };
  }
}
