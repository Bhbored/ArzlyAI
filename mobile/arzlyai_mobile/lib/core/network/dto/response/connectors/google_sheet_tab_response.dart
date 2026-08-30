class GoogleSheetTabResponse {
  const GoogleSheetTabResponse({
    required this.id,
    required this.title,
    required this.index,
    required this.rowCount,
    required this.columnCount,
  });

  factory GoogleSheetTabResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSheetTabResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      index: json['index'] as int,
      rowCount: json['rowCount'] as int,
      columnCount: json['columnCount'] as int,
    );
  }

  final int id;
  final String title;
  final int index;
  final int rowCount;
  final int columnCount;
}
