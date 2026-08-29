namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record ScheduleWorkflowRequest(TimeOnly LocalTime, string TimeZoneId);
