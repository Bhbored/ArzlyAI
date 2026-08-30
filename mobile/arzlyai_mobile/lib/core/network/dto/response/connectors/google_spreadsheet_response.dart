class GoogleSpreadsheetResponse {
  const GoogleSpreadsheetResponse({
    required this.id,
    required this.name,
    this.modifiedAtUtc,
  });

  factory GoogleSpreadsheetResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSpreadsheetResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      modifiedAtUtc: DateTime.tryParse(json['modifiedAtUtc'] as String? ?? ''),
    );
  }

  final String id;
  final String name;
  final DateTime? modifiedAtUtc;
}
