namespace ArzlyAI.Application.DTOs.Connectors;

public sealed record GoogleSheetTabResponse(
    int Id,
    string Title,
    int Index,
    int RowCount,
    int ColumnCount);
