import { test, expect, type Page } from "@playwright/test"
import { preview, type PreviewServer } from "vite"
import { emptyDraft } from "../src/app/features/sessions/draftEditorModel"
import type { AuthoringSession, Capability } from "../src/app/shared/types"

let server: PreviewServer
let origin: string
const sessionId = "00000000-0000-0000-0000-000000000001"
const auth = { adminId: "test-admin", displayName: "Test admin", email: "test@example.invalid",
  accessToken: "test-token", refreshToken: "test-refresh", accessTokenExpiresAtUtc: "2099-01-01T00:00:00Z", refreshTokenExpiresAtUtc: "2099-01-01T00:00:00Z" }
const integration: Capability = { key: "google.sheets.read", kind: "Integration", displayName: "Google Sheets Read", description: "Read spreadsheet rows.",
  connectorKey: "google", inputSchemaJson: '{"type":"object","required":["spreadsheetId"],"properties":{"spreadsheetId":{"type":"string"}}}',
  outputSchemaJson: "{}", requiredOAuthScopesJson: "[]", requiredApisJson: "[]", documentationLinksJson: "[]", riskLevel: "Read", supportsBackgroundExecution: true }
const operation: Capability = { ...integration, key: "receipt.analyze", kind: "Operation", displayName: "Receipt analysis", connectorKey: null }

test.beforeAll(async () => {
  server = await preview({ preview: { host: "127.0.0.1", port: 0, open: false }, mode: "production" })
  const address = server.httpServer.address()
  if (!address || typeof address === "string") throw new Error("Preview server has no address")
  origin = `http://127.0.0.1:${address.port}`
})
test.afterAll(async () => { await new Promise<void>((resolve, reject) => server.httpServer.close(error => error ? reject(error) : resolve())) })

async function setup(page: Page) {
  let session: AuthoringSession = { id: sessionId, title: "Workspace test", status: "Active", revision: 1,
    assistantModel: { provider: "test", model: "test-model" }, draft: { ...emptyDraft(), title: "Test workflow" },
    validation: { errors: [] }, publishedPresetId: null, createdAtUtc: "2026-01-01T00:00:00Z", updatedAtUtc: "2026-01-01T00:00:00Z",
    draftRevision: 1, validatedDraftRevision: 1, turn: null, publishReadiness: { canPublish: false, blockers: ["Add workflow steps."] },
    messages: [{ id: "message-1", sequence: 1, role: "Assistant", toolName: null, createdAtUtc: "2026-01-01T00:00:00Z",
      content: `Long message: ${"unbroken".repeat(150)}\n\n\`\`\`json\n${"x".repeat(450)}\n\`\`\`\n\n| Column one | Column two |\n| --- | --- |\n| ${"a".repeat(200)} | table content |\n\nEnd of the complete response.` }] }
  await page.addInitScript(value => sessionStorage.setItem("arzlyai.admin.auth", JSON.stringify({ user: value, tokens: value })), auth)
  await page.route("**/api/**", async route => {
    const path = new URL(route.request().url()).pathname
    if (path.endsWith("/auth/refresh")) return route.fulfill({ json: auth })
    if (path.includes("/hubs/")) return route.fulfill({ status: 503, json: { message: "Live connection intentionally unavailable in UI tests." } })
    if (path.endsWith("/capabilities")) return route.fulfill({ json: [integration, operation] })
    if (path.endsWith("/runtime-models")) return route.fulfill({ json: [{ provider: "test", model: "test-model", displayName: "Test model" }] })
    if (path.endsWith("/assistant-models")) return route.fulfill({ json: [{ provider: "test", model: "test-model", displayName: "Test model", isDefault: true }] })
    if (path.endsWith("/assistant-providers")) return route.fulfill({ json: [] })
    if (path.endsWith("/draft")) {
      const body = route.request().postDataJSON()
      session = { ...session, draft: body.draft, revision: session.revision + 1, draftRevision: session.draftRevision + 1 }
      return route.fulfill({ json: session })
    }
    if (path.endsWith(`/sessions/${sessionId}`)) return route.fulfill({ json: session })
    if (path.endsWith("/sessions") && route.request().method() === "POST") {
      expect(route.request().postDataJSON().useVisualBuilder).toBe(true)
      return route.fulfill({ status: 201, json: session })
    }
    if (path.endsWith("/session-summaries")) return route.fulfill({ json: [session] })
    if (path.endsWith("/presets")) return route.fulfill({ json: [] })
    return route.fulfill({ status: 404, json: {} })
  })
}

test("integrations exclude built-in processing rows and catalog opens the builder", async ({ page }) => {
  await setup(page)
  await page.goto(`${origin}/capabilities`)
  await expect(page).toHaveURL(/\/integrations$/)
  await expect(page.getByRole("cell", { name: "Google Sheets Read", exact: true })).toBeVisible()
  await expect(page.getByText("Receipt analysis", { exact: true })).toHaveCount(0)
  await page.getByRole("link", { name: "Catalog", exact: true }).click()
  await page.getByRole("button", { name: "Create workflow" }).click()
  await expect(page.getByRole("tab", { name: "Workflow builder", exact: true })).toHaveAttribute("data-state", "active")
  await expect(page.getByLabel("Workflow canvas", { exact: true })).toBeVisible()
})

test("builder supports drag, keyboard add, linked agent settings, and saved layout", async ({ page }, testInfo) => {
  await setup(page)
  await page.setViewportSize({ width: 1600, height: 1000 })
  const errors: string[] = []
  page.on("pageerror", error => errors.push(error.message))
  await page.goto(`${origin}/sessions/${sessionId}?tab=builder`)
  const addAgent = page.getByRole("button", { name: "Add AI agent", exact: true })
  await addAgent.focus(); await page.keyboard.press("Enter")
  await page.getByLabel("Agent instructions", { exact: true }).fill("Summarize the spreadsheet for review.")
  await page.getByRole("button", { name: "Add Google Sheets Read", exact: true }).dragTo(page.getByLabel("Workflow canvas", { exact: true }), { targetPosition: { x: 500, y: 80 } })
  await expect(page.getByText("Required inputs: spreadsheetId")).toBeVisible()
  await page.getByRole("button", { name: "Add required mappings" }).click()
  await expect(page.getByLabel("Step input", { exact: true })).toHaveValue("spreadsheetId")
  await page.getByLabel("Source path or $.literal.value", { exact: true }).fill("$.literal.example-sheet")
  await page.getByText("Connections and workflow settings", { exact: true }).click()
  await page.getByLabel("From step", { exact: true }).selectOption("step-2")
  await page.getByLabel("To step", { exact: true }).selectOption("step-1")
  await page.getByRole("button", { name: "Connect steps", exact: true }).click()
  await expect(page.locator(".react-flow__edge")).toHaveCount(1)
  await page.getByRole("button", { name: "Save draft", exact: true }).click()
  await expect(page.getByText("Saved draft", { exact: false }).first()).toBeVisible()
  await page.getByRole("tab", { name: "Chat", exact: true }).click()
  await expect(page.getByRole("region", { name: "Chat messages" })).toBeVisible()
  await page.getByRole("tab", { name: "Workflow builder", exact: true }).click()
  await expect(page.locator(".react-flow__node")).toHaveCount(2)
  await page.reload()
  await expect(page.locator(".react-flow__node")).toHaveCount(2)
  await expect(page.locator(".react-flow__node").first()).toBeVisible()
  await page.getByRole("button", { name: "AI agent", exact: true }).click()
  await expect(page.getByLabel("Agent instructions", { exact: true })).toHaveValue("Summarize the spreadsheet for review.")
  await expect(page.locator(".react-flow__edge")).toHaveCount(1)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.evaluate(() => window.scrollTo(0, 0))
  await page.screenshot({ path: testInfo.outputPath("workflow-builder.png"), fullPage: true })
  expect(errors).toEqual([])
})

for (const width of [390, 900, 1440]) {
  test(`complete chat messages fit at ${width}px`, async ({ page }, testInfo) => {
    await setup(page)
    await page.setViewportSize({ width, height: 900 })
    await page.goto(`${origin}/sessions/${sessionId}`)
    const messages = page.getByRole("region", { name: "Chat messages" })
    await expect(messages.getByText("End of the complete response.")).toBeVisible()
    expect(await messages.evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.getByRole("tab", { name: "Workflow builder", exact: true }).click()
    await expect(page.getByLabel("Workflow canvas", { exact: true })).toBeVisible()
    const tabs = await page.getByRole("tablist", { name: "Workflow sections" }).boundingBox()
    const heading = await page.getByRole("heading", { name: "Workflow canvas", exact: true }).boundingBox()
    expect(tabs && heading && tabs.y + tabs.height <= heading.y).toBeTruthy()
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`builder-${width}.png`), fullPage: true })
  })
}
