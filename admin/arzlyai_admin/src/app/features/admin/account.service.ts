import { apiFetch } from "../../shared/api/http"

export async function changePassword(
  currentPassword: string,
  newPassword: string,
) {
  return apiFetch<void>("/api/v1/admin/auth/change-password", {
    method: "POST",
    body: JSON.stringify({ currentPassword, newPassword }),
  })
}
