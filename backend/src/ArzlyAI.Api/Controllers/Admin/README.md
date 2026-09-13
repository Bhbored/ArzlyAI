# Admin Controllers

Administration-only endpoints live here. They use explicit API versioning, the standard `Admin` Identity role, admin-specific rate limits, and the `api/v{version:apiVersion}/admin/...` route prefix.

- `AdminAuthController`: Identity-backed login, JSON refresh-token rotation, logout, and password change for the one seeded administrator.
- `PresetAuthoringController`: persistent AI authoring sessions, tool-capable configured-model discovery/selection, validation, capability discovery, and explicit publication.
- `AdminPresetsController`: immutable version inspection, clone-to-draft, and archive operations.

There is no registration, invitation, or account-management controller. Do not expose admin notes from public controllers. An authoring chat may update a draft but must never publish it; publication remains a separate revision-checked endpoint.
