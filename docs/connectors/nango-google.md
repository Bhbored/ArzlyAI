# Nango Google Connectors

ArzlyAI uses **four standalone Nango OAuth connectors** for Google services (same pattern as LinkedIn). The backend stores neither OAuth tokens nor device connections. It tags every Nango connect session with the mobile-generated device UUID and resolves connections from Nango on demand.

| Connector key | Nango integration ID | Integrations |
| --- | --- | --- |
| `google-sheets` | `google-sheets` | `google.sheets.read`, `google.sheets.report`, `google.sheets.write` |
| `gmail` | `gmail` | `google.gmail.send-html` |
| `google-tasks` | `google-tasks` | `google.tasks.create` |
| `google-calendar` | `google-calendar` | `google.calendar.create-events` |

Integration handlers still read envelope fields `google.accessToken` and `google.email` from the short-lived approval envelope — never from PostgreSQL.

## Configuration

Set these values through environment variables or user secrets:

```text
Nango__ApiKey=<environment API key>
Nango__BaseUrl=https://api.nango.dev
Nango__GoogleSheetsIntegrationId=google-sheets
Nango__GmailIntegrationId=gmail
Nango__GoogleTasksIntegrationId=google-tasks
Nango__GoogleCalendarIntegrationId=google-calendar
```

The Nango API key needs:

- `environment:connect_sessions:write`
- `environment:connections:list`
- `environment:connections:read_credentials`
- `environment:connections:delete`

Create **four separate Google integrations** in the Nango dashboard, each with only the scopes that connector needs. Users reconnect per service when scopes change.

## OAuth scopes (per connector)

| Connector | Scopes |
| --- | --- |
| `google-sheets` | `https://www.googleapis.com/auth/spreadsheets`, `https://www.googleapis.com/auth/drive.file` |
| `gmail` | `https://mail.google.com/` or `https://www.googleapis.com/auth/gmail.send` |
| `google-tasks` | `https://www.googleapis.com/auth/tasks` |
| `google-calendar` | `https://www.googleapis.com/auth/calendar.events` |

## Mobile flow

Mobile generates a random UUID once, stores it locally, and supplies it as `X-Device-Id` on every request.

Each connector exposes the same REST shape under its key:

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `POST` | `/api/v1/connectors/{connectorKey}/session` | Start connect session |
| `GET` | `/api/v1/connectors/{connectorKey}/status` | Connection status |
| `GET` | `/api/v1/connectors/{connectorKey}/credentials` | Mapped connector fields |
| `DELETE` | `/api/v1/connectors/{connectorKey}` | Disconnect |

Google credential response (mapped keys — same for all four connectors):

```json
{
  "google.accessToken": "<access-token>",
  "google.email": "person@example.com"
}
```

Mobile copies these into platform secure storage via **Sync credentials** on each connector card (`Settings → Connectors`).

Sheets-specific resource routes:

| Method | Endpoint |
| --- | --- |
| `GET` | `/api/v1/connectors/google-sheets/resources/spreadsheets` |
| `GET` | `/api/v1/connectors/google-sheets/resources/spreadsheets/{id}/tabs` |
| `GET` | `/api/v1/connectors/google-sheets/resources/spreadsheets/{id}/tabs/{tab}/headers` |

## Backend mapping

`NangoConnectorBroker` maps each connector key to its Nango integration ID and normalizes credentials to:

- `google.accessToken`
- `google.email`

Register clients and handlers in `DIContainer.RegisterIntegrations`:

- `GoogleSheetsClient` / Sheets handlers (receipt presets)
- `GmailHtmlIntegrationHandler`
- `GoogleTasksClient` / `GoogleTasksCreateIntegrationHandler`
- `GoogleCalendarClient` / `GoogleCalendarCreateEventsIntegrationHandler`

## Mobile files

- `mobile/arzlyai_mobile/lib/core/credentials/connector_keys.dart` — `ConnectorKeys.googleSheets`, `gmail`, `googleTasks`, `googleCalendar`
- `mobile/arzlyai_mobile/lib/core/credentials/connector_integration_support.dart` — integration ↔ connector maps
- `mobile/arzlyai_mobile/lib/ui/features/settings/settings_connectors_screen.dart`
- `mobile/arzlyai_mobile/lib/ui/features/settings/settings_google_sheets_connector_screen.dart`
- `mobile/arzlyai_mobile/lib/ui/features/settings/settings_gmail_connector_screen.dart`
- `mobile/arzlyai_mobile/lib/ui/features/settings/settings_google_tasks_connector_screen.dart`
- `mobile/arzlyai_mobile/lib/ui/features/settings/settings_google_calendar_connector_screen.dart`
- `mobile/arzlyai_mobile/lib/ui/shared/widgets/app_connector_card.dart`
