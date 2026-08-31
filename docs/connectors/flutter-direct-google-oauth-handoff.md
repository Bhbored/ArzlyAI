# Deprecated: Backend-Brokered Google OAuth

This handoff is obsolete. Google authorization now runs natively in Flutter via `google_sign_in`.

See [google-oauth.md](./google-oauth.md) for the current Android/iOS client setup, Settings flow, encrypted envelope contract, and background limitations.

The backend no longer exposes:

- `POST /connectors/{key}/session`
- `GET /connectors/{key}/status`
- `GET /connectors/google/callback`
- `GET /connectors/{key}/credentials`
- `POST /connectors/{key}/credentials/refresh`
- `DELETE /connectors/{key}`

Google Sheets resource selection still uses `POST .../query` with `{ "credentials": <CredentialEnvelope> }`.
