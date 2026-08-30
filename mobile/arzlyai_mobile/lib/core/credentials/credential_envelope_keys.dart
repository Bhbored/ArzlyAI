import 'package:arzlyai_mobile/core/credentials/credential_schema.dart';

String providerCredentialEnvelopeKey(String providerKey) =>
    '$providerKey.apiKey';

String integrationFieldEnvelopeKey(String integrationKey, String field) {
  final prefix = integrationKey.split('.').first;
  if (field.startsWith('$prefix.')) return field;
  return '$prefix.$field';
}

List<String> envelopeKeysForProvider(String providerKey) {
  return [providerCredentialEnvelopeKey(providerKey)];
}

List<String> envelopeKeysForIntegration(
  String integrationKey,
  String credentialSchemaJson,
) {
  final schema = CredentialSchema.parse(credentialSchemaJson);
  return schema.fields
      .map((field) => integrationFieldEnvelopeKey(integrationKey, field))
      .toList();
}

bool credentialFieldShouldObscure(String field) {
  final lower = field.toLowerCase();
  return lower.contains('token') ||
      lower.contains('key') ||
      lower.contains('secret') ||
      lower.contains('password');
}
