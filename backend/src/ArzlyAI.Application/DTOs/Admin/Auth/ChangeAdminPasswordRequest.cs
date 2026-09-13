namespace ArzlyAI.Application.DTOs.Admin.Auth;

public sealed record ChangeAdminPasswordRequest(string CurrentPassword, string NewPassword);
