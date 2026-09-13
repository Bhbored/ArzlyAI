import path from "node:path"
import { fileURLToPath } from "node:url"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig, loadEnv } from "vite"

const rootDir = path.dirname(fileURLToPath(import.meta.url))

function apiProxy(env: Record<string, string>) {
  const target = env.VITE_API_PROXY_TARGET?.trim()
  if (!target) return undefined

  const insecureTls = env.VITE_PROXY_INSECURE_TLS === "true"

  return {
    "/api": {
      target,
      changeOrigin: true,
      ws: true,
      // false = accept self-signed/dev certs (Node proxy only; not the browser)
      secure: !insecureTls,
    },
  }
}

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, rootDir, "")
  const proxy = apiProxy(env)

  return {
    plugins: [react(), tailwindcss()],
    resolve: {
      alias: {
        "@": path.resolve(rootDir, "./src"),
      },
    },
    server: {
      proxy,
    },
    preview: {
      proxy,
    },
  }
})
