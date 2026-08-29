import 'dart:convert';

class CredentialSchema {
  const CredentialSchema({this.type, required this.fields});

  final String? type;
  final List<String> fields;

  static CredentialSchema parse(String schemaJson) {
    try {
      final map = jsonDecode(schemaJson) as Map<String, dynamic>;
      final type = map['type'];
      final fields = map['fields'];
      return CredentialSchema(
        type: type is String ? type : null,
        fields: fields is List
            ? fields.map((field) => field.toString()).toList()
            : const [],
      );
    } catch (_) {
      return const CredentialSchema(fields: []);
    }
  }
}
