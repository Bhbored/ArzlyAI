# ArzlyAI Admin

React + TypeScript administration client for preset authoring and catalog management.

**Stack:** React 19 · Vite · Tailwind CSS v4 · shadcn/ui · TanStack Query · React Router · SignalR

## Scripts

```powershell
npm install
npm run dev          # development mode → local HTTPS API via proxy
npm run dev:test     # test mode
npm run build        # production build
npm run build:test   # test build
npm run lint
npm run preview
```

Vite 8 breaks when the project path contains `#` (this repo lives under `Documents\C#\...`). Run the dev server from a junction without that character:

```powershell
# one-time
cmd /c mklink /J "%USERPROFILE%\Documents\CSharp\ASP\ArzlyAI" "%USERPROFILE%\Documents\C#\ASP\ArzlyAI"

cd %USERPROFILE%\Documents\CSharp\ASP\ArzlyAI\admin\arzlyai_admin
npm run dev
```

Or use `npx vite --port 5173` from that junction path.

## Environment

Modes load `.env.[mode]` (and optional gitignored `.env.[mode].local`):

| Mode | Command | Typical use |
| --- | --- | --- |
| `development` | `npm run dev` | Local API with self-signed HTTPS |
| `test` | `npm run dev:test` / `build:test` | Shared test API |
| `production` | `npm run build` | Deployed admin + trusted API cert |

| Variable | Purpose |
| --- | --- |
| `VITE_API_BASE_URL` | Optional API origin for the browser. Leave empty so `/api` stays same-origin and uses the Vite proxy. |
| `VITE_API_PROXY_TARGET` | Upstream for the proxy (e.g. `https://localhost:7029`). |
| `VITE_PROXY_INSECURE_TLS` | `true` in development/test so the **Node proxy** accepts a bad/self-signed cert. Always `false` in production. |

Browsers cannot ignore TLS errors. Keep `VITE_API_BASE_URL` empty in local modes so the app calls Vite, and the proxy (with `secure: false`) talks to HTTPS. If you set `VITE_API_BASE_URL` to `https://…`, the browser must trust that certificate.

## Routes

| Path | Page |
| --- | --- |
| `/login` | Admin login |
| `/` | Dashboard |
| `/sessions` | Authoring sessions |
| `/sessions/:id` | Chat + draft workspace |
| `/presets` | Catalog versions |
| `/presets/:key/:version` | Version detail |
| `/capabilities` | Capability browser |
| `/account` | Change password |

Run the API with the **https** launch profile (`https://localhost:7029`) while developing. Auth tokens are kept in memory and `sessionStorage` (not `localStorage`).
