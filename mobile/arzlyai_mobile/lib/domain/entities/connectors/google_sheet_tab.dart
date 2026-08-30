class GoogleSheetTab {
  const GoogleSheetTab({
    required this.id,
    required this.title,
    required this.index,
    required this.rowCount,
    required this.columnCount,
  });

  final int id;
  final String title;
  final int index;
  final int rowCount;
  final int columnCount;
}
