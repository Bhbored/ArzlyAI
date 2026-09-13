# React admin handoff: simplified Identity/JWT backend

## Context

The backend admin security layer now follows the sample project's standard ASP.NET Core Identity and JWT bearer pattern. It uses the Identity `Admin` role through `[Authorize(Roles = "Admin")]`; the custom `Admin` authorization policy and per-request security-stamp database check were removed.

The React admin API routes, request bodies, and response JSON are unchanged. Do not rename fields or add cookie authentication.

## Backend contract

All admin endpoints require `Authorization: Bearer <accessToken>` except:

- `POST /api/v1/admin/auth/login`
- `POST /api/v1/admin/auth/refresh`

Login and refresh still use this exact JSON shape:

```json
{
  "adminId": "guid",
  "email": "admin@example.com",
  "displayName": "Administrator",
  "accessToken": "jwt",
  "accessTokenExpiresAtUtc": "2026-09-07T12:00:00Z",
  "refreshToken": "rotated-token",
  "refreshTokenExpiresAtUtc": "2026-10-07T12:00:00Z"
}
```

`POST /api/v1/admin/auth/logout` and `POST /api/v1/admin/auth/change-password` remain protected and return `204`. Refresh tokens are rotated and stored server-side only as hashes. No frontend role parsing or role-based UI is required: a user who is not an `Admin` receives `403` from protected endpoints.

## Required React changes

### Proactively refresh protected HTTP requests

`useAuthoringHub` already calls `ensureFreshAccessToken()` before SignalR connects. Make `apiFetch` do the same for every authenticated HTTP request instead of reading `getAccessToken()` directly.

In `src/app/shared/api/http.ts`, replace the protected-request token lookup with an awaited `ensureFreshAccessToken()` call before adding the `Authorization` header. Keep the existing single `401` refresh-and-retry fallback for races, revoked refresh tokens, and server-clock differences.

This prevents normal access-token expiry from first producing a visible/backend-logged `401` on requests such as `GET /api/v1/admin/presets`.

Do not add bearer authentication to the refresh request itself: it must continue to send only its JSON access-token/refresh-token pair. Do not add browser cookies or persist tokens outside `sessionStorage`.

### Correct password-change messaging

In `src/app/features/admin/pages/AccountPage.tsx`, replace the statement that password changes “invalidate existing JWTs.” The simplified backend revokes refresh tokens; issued access JWTs remain valid until `accessTokenExpiresAtUtc`.

Keep the existing successful-password-change behavior: clear the local session and require a fresh login immediately. This protects the current browser session even though other clients’ already-issued access tokens expire naturally.

### Stale-session behavior

Keep `AuthProvider`’s startup refresh. If refresh fails, clear `arzlyai.admin.auth` from `sessionStorage` and redirect to `/login`; do not repeatedly retry protected queries.

Older browser state may contain a refresh token invalidated during the Identity migration or by logout/password change. Treat that as an ordinary sign-in-again condition, not as an API configuration error.

## What does not need to change

- `AdminAuthenticationResponse`, `AuthTokens`, and `AdminUser` TypeScript types.
- Login, refresh, logout, change-password, authoring, catalog, and capability endpoint paths.
- The Vite proxy settings or `VITE_API_BASE_URL` behavior.
- `ProtectedRoute` and `useAuthoringHub` routing/token-factory structure.
- SignalR’s `accessTokenFactory`; the backend still accepts the token on the admin hub query string as required by browser WebSockets.

## Verification

1. Start with an empty `sessionStorage`, sign in, and confirm `GET /api/v1/admin/presets` contains a bearer header and returns `200`.
2. Set the stored access-token expiry to within the refresh skew window, then load a protected page. Confirm refresh occurs before the catalog request and the catalog request succeeds without an initial `401`.
3. Use an invalid refresh token. Confirm storage is cleared and the app navigates to login after one failed refresh attempt.
4. Confirm the SignalR authoring hub still connects after a proactive refresh.
5. Change the password. Confirm the app signs out locally and the old refresh token is rejected, while the UI no longer claims all outstanding JWTs were instantly invalidated.

Run `npm run build` from `admin/arzlyai_admin` after the changes.

## Backend references

- `backend/src/ArzlyAI.Api/Helpers/DIContainer.cs`
- `backend/src/ArzlyAI.Api/Controllers/Admin/AdminAuthController.cs`
- `backend/src/ArzlyAI.Infrastructure/Security/AuthService.cs`
- `docs/admin/react-admin-contract.md`
