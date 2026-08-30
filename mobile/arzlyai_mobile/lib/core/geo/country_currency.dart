String currencyCodeForCountry(String countryCode) {
  return switch (countryCode.toUpperCase()) {
    'US' => 'USD',
    'GB' => 'GBP',
    'CA' => 'CAD',
    'AU' => 'AUD',
    'NZ' => 'NZD',
    'JP' => 'JPY',
    'CN' => 'CNY',
    'IN' => 'INR',
    'MX' => 'MXN',
    'BR' => 'BRL',
    'CH' => 'CHF',
    'SE' => 'SEK',
    'NO' => 'NOK',
    'DK' => 'DKK',
    'PL' => 'PLN',
    'TR' => 'TRY',
    'SA' => 'SAR',
    'AE' => 'AED',
    'LB' => 'USD',
    'DE' || 'FR' || 'IT' || 'ES' || 'NL' || 'BE' || 'AT' || 'IE' || 'PT' ||
    'FI' || 'GR' =>
      'EUR',
    _ => 'USD',
  };
}
