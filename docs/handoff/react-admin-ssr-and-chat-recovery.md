# React admin SSR and authoring chat handoff

This handoff is for the React admin agent. Backend ownership remains with the backend agent.

## Backend status

- The admin API remains a bearer-token API. SSR requests must forward an administrator `Authorization: Bearer <access-token>` header when calling protected routes.
- Do not put access tokens or refresh tokens in rendered HTML, React Query dehydrated state, page props, or script tags.
- The current browser auth implementation stores tokens in browser storage, so it cannot authenticate protected SSR requests by itself. Until an httpOnly-cookie auth flow is agreed and implemented by the backend, render the protected admin shell client-side after hydration or use a separate trusted server session.
- The backend does not need an SSR-specific API route. Existing relative API routes can be called by the SSR server with the forwarded bearer token.

## Vite SSR migration

The app currently uses Vite 8, React 19, React Router 7, and `src/main.tsx` with `createRoot`. Add the standard Vite SSR split:

- `src/app/App.tsx`: framework-neutral application tree.
- `src/entry-client.tsx`: call `hydrateRoot` against the server markup, with `StrictMode` if desired.
- `src/entry-server.tsx`: render with `renderToString` and a static router for the requested URL.
- `server.ts`: use Vite middleware mode in development and serve `dist/client` plus the built SSR entry in production.
- Add client and server build scripts. The server build must use `vite build --ssr src/entry-server.tsx`.
- Add `<!--ssr-outlet-->` to `index.html` and keep the client entry script in the template.

## Auth and data loading rules

- Login and token refresh are browser flows today. Do not attempt to read `localStorage` from the server entry.
- Public routes may be server-rendered immediately.
- Protected admin routes should return a deterministic loading or auth boundary during SSR, then fetch authoring data after the client has restored auth. Avoid rendering a fake authenticated dashboard.
- If true authenticated SSR is required, coordinate a backend change to issue and validate secure httpOnly cookies. That change must include CSRF protection and logout cookie clearing; do not invent a second token format in the React server.
- Keep SignalR and other browser-only APIs out of the server entry. Start the authoring hub only after hydration.

## Second-turn chat behavior

- `POST /api/v1/admin/authoring/sessions/{id}/messages` accepts `{ content, expectedRevision }` and returns `{ session, assistantMessage }`.
- Replace the cached session with the complete returned `session`; treat `revision` as opaque. Never increment it in the client.
- Keep the composer disabled while a turn is active and prevent duplicate submits. Do not submit whitespace or an empty string.
- A `409` means the cached session is stale or immutable. Reload the session before allowing another send.
- The backend now tolerates blank DeepSeek no-argument tool arguments and returns malformed draft input to the model as a tool error so a turn can recover instead of failing the whole request.
- If a turn still fails, show the server error and refetch the session. Do not append an optimistic assistant message.

## Verification

Run the existing client build after the SSR split and verify direct navigation, refresh, login, logout, protected-route redirects, hydration without mismatch warnings, and a two-message authoring chat. The backend build and test suite currently pass with 134 tests.
