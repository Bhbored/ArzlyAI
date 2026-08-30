class GoogleSpreadsheet {
  const GoogleSpreadsheet({
    required this.id,
    required this.name,
    this.modifiedAtUtc,
  });

  final String id;
  final String name;
  final DateTime? modifiedAtUtc;
}
