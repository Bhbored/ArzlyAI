/// <reference types="vite/client" />

interface ImportMetaEnv {
  /** Empty = same-origin + Vite proxy; otherwise absolute API origin. */
  readonly VITE_API_BASE_URL?: string
  /** Upstream for the Vite /api proxy (server-side only via loadEnv). */
  readonly VITE_API_PROXY_TARGET?: string
  /** "true" → proxy accepts untrusted HTTPS certs (dev/test only). */
  readonly VITE_PROXY_INSECURE_TLS?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
