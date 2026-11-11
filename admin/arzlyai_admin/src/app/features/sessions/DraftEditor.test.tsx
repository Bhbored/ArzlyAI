import { afterEach, expect, it, vi } from "vitest"
import { cleanup, render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import type { AuthoringSession } from "../../shared/types"
import { appendWorkflowStep, canConnectWorkflow, emptyDraft, newNode, removeNode, renameInput, renameNode } from "./draftEditorModel"
import { DraftEditor } from "./DraftEditor"

vi.mock("./WorkflowCanvas", () => ({ WorkflowCanvas: () => null, componentDragType: "application/arzly-workflow-component" }))
vi.mock("./sessions.service", () => ({
  fetchRuntimeModels: async () => [],
  saveDraft: vi.fn(), previewDraft: vi.fn(),
  sessionKeys: { detail: (id: string) => ["authoring-sessions", "detail", id], list: () => ["authoring-sessions", "list"] },
}))

afterEach(cleanup)

function session(revision: number): AuthoringSession {
  return { id: "session-1", title: "Saved", status: "Active", revision,
    assistantModel: { provider: "test", model: "test" }, draft: { ...emptyDraft(), title: "Saved" },
    validation: { errors: [] }, publishedPresetId: null, messages: [],
    createdAtUtc: "2026-01-01T00:00:00Z", updatedAtUtc: "2026-01-01T00:00:00Z",
    draftRevision: revision, validatedDraftRevision: revision, turn: null,
    publishReadiness: { canPublish: false, blockers: [] } }
}

it("preserves unsaved edits when the server revision changes and lets the admin choose the saved draft", async () => {
  const queryClient = new QueryClient({ defaultOptions: { queries: { retry: false } } })
  const user = userEvent.setup()
  const onDirtyChange = vi.fn()
  const view = render(<QueryClientProvider client={queryClient}>
    <DraftEditor session={session(1)} capabilities={[]} locked={false} onDirtyChange={onDirtyChange} />
  </QueryClientProvider>)
  await user.click(screen.getByRole("tab", { name: "Details" }))
  await user.clear(screen.getByLabelText("Title"))
  await user.type(screen.getByLabelText("Title"), "My edit")
  expect(screen.getByLabelText("Title")).toHaveProperty("value", "My edit")
  view.rerender(<QueryClientProvider client={queryClient}>
    <DraftEditor session={session(2)} capabilities={[]} locked={false} onDirtyChange={onDirtyChange} />
  </QueryClientProvider>)
  expect(screen.getByText(/saved chat changed while you were editing/i)).toBeDefined()
  expect(screen.getByLabelText("Title")).toHaveProperty("value", "My edit")
  await user.click(screen.getByRole("button", { name: "Use latest saved draft" }))
  expect(screen.getByLabelText("Title")).toHaveProperty("value", "Saved")
  expect(onDirtyChange).toHaveBeenLastCalledWith(false)
})

it("renames connected node references and removes its edges", () => {
  const draft = emptyDraft()
  draft.workflow.nodes = [
    { key: "first", displayName: "First", type: "Agent", referenceKey: "agent", position: 0,
      inputMappingJson: "{}", requiresHumanApproval: false, configurationJson: null, resultContractKey: null, resultContractVersion: null },
    { key: "second", displayName: "Second", type: "Operation", referenceKey: "format", position: 1,
      inputMappingJson: '{"source":"$.nodes.first.output"}', requiresHumanApproval: false,
      configurationJson: null, resultContractKey: null, resultContractVersion: null },
  ]
  draft.workflow.connections = [{ sourceNodeKey: "first", targetNodeKey: "second" }]
  const renamed = renameNode(draft, "first", "intro")
  expect(renamed.workflow.connections[0].sourceNodeKey).toBe("intro")
  expect(renamed.workflow.nodes[1].inputMappingJson).toContain("$.nodes.intro.output")
  expect(removeNode(renamed, "intro").workflow.connections).toHaveLength(0)
})

it("updates required and optional input mappings when an input is renamed", () => {
  const draft = emptyDraft()
  draft.workflow.nodes = [{ key: "step", displayName: "Step", type: "Agent", referenceKey: "agent", position: 0,
    inputMappingJson: '{"one":"$.inputs.old","two":"$.inputs.old?","other":"$.inputs.older"}',
    requiresHumanApproval: false, configurationJson: null, resultContractKey: null, resultContractVersion: null }]
  const mapping = JSON.parse(renameInput(draft, "old", "new").workflow.nodes[0].inputMappingJson)
  expect(mapping).toEqual({ one: "$.inputs.new", two: "$.inputs.new?", other: "$.inputs.older" })
})

it("creates the agent behind a canvas component and stores its drop position", () => {
  const draft = appendWorkflowStep(emptyDraft(), { id: "new-agent", type: "Agent", referenceKey: "", name: "AI agent", description: "" },
    { x: 100, y: 200 }, { provider: "test", model: "test-model" })
  expect(draft.agents).toHaveLength(1)
  expect(draft.workflow.nodes[0].referenceKey).toBe(draft.agents[0].key)
  expect(draft.agents[0].modelKey).toBe("test-model")
  expect(draft.workflow.nodes[0].editorPosition).toEqual({ x: 100, y: 200 })
})

it("rejects a canvas connection that would make a cycle", () => {
  const draft = emptyDraft()
  draft.workflow.nodes = [newNode("first", 0), newNode("second", 1), newNode("last", 2)]
  draft.workflow.connections = [{ sourceNodeKey: "first", targetNodeKey: "second" }, { sourceNodeKey: "second", targetNodeKey: "last" }]
  expect(canConnectWorkflow(draft, "last", "first")).toBe(false)
  expect(canConnectWorkflow(draft, "first", "second")).toBe(false)
  expect(canConnectWorkflow(draft, "first", "last")).toBe(true)
})
