import { useEffect, useState } from "react"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { toast } from "sonner"
import { Button } from "@/components/ui/button"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import type { AuthoringPreview, AuthoringSession, Capability, PresetDraft } from "../../shared/types"
import { ApiError } from "../../shared/api/http"
import { Field, Choice, Toggle, JsonField } from "./EditorFields"
import { SchemaEditor } from "./SchemaEditor"
import { WorkflowBuilder } from "./WorkflowBuilder"
import { emptyDraft, enumName, newAgent, renameInput, uniqueKey } from "./draftEditorModel"
import { fetchRuntimeModels, previewDraft, saveDraft, sessionKeys } from "./sessions.service"

const severityNames = ["Information", "Warning", "RequiredAction"]
const backgroundNames = ["NotApplicable", "Optional", "Recommended"]

export function DraftEditor({ session, capabilities, locked, onDirtyChange }: {
  session: AuthoringSession; capabilities: Capability[]; locked: boolean; onDirtyChange: (dirty: boolean) => void
}) {
  const queryClient = useQueryClient()
  const modelsQuery = useQuery({ queryKey: ["runtime-models"], queryFn: fetchRuntimeModels, staleTime: 300_000 })
  const [draft, setDraft] = useState<PresetDraft>(() => structuredClone(session.draft ?? emptyDraft()))
  const [baseRevision, setBaseRevision] = useState(session.revision)
  const [dirty, setDirty] = useState(false)
  const [conflict, setConflict] = useState(false)
  const [editorTab, setEditorTab] = useState("workflow")
  const [sampleText, setSampleText] = useState("{}")
  const [preview, setPreview] = useState<AuthoringPreview | null>(null)
  const [serverRevisionSeen, setServerRevisionSeen] = useState(session.revision)

  if (serverRevisionSeen !== session.revision) {
    setServerRevisionSeen(session.revision)
    if (dirty) setConflict(true)
    else { setDraft(structuredClone(session.draft ?? emptyDraft())); setBaseRevision(session.revision); setConflict(false) }
  }

  useEffect(() => {
    if (!dirty) return
    const warn = (event: BeforeUnloadEvent) => { event.preventDefault(); event.returnValue = "" }
    window.addEventListener("beforeunload", warn)
    return () => window.removeEventListener("beforeunload", warn)
  }, [dirty])

  const update = (next: PresetDraft) => {
    setDraft(next); setDirty(true); setPreview(null); onDirtyChange(true)
  }
  const reset = () => {
    setDraft(structuredClone(session.draft ?? emptyDraft())); setBaseRevision(session.revision)
    setDirty(false); setConflict(false); setPreview(null); onDirtyChange(false)
  }
  const save = useMutation({
    mutationFn: () => saveDraft(session.id, baseRevision, draft),
    onSuccess: saved => {
      queryClient.setQueryData(sessionKeys.detail(session.id), saved)
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() })
      setBaseRevision(saved.revision); setDirty(false); setConflict(false); onDirtyChange(false)
      toast.success("Draft saved", { description: saved.validation.errors.length
        ? `${saved.validation.errors.length} issue(s) need attention.` : "Ready for review." })
    },
    onError: error => {
      if (error instanceof ApiError && error.status === 409) {
        setConflict(true)
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(session.id) })
      }
      toast.error("Could not save draft", { description: error instanceof Error ? error.message : undefined })
    },
  })
  const runPreview = useMutation({
    mutationFn: () => previewDraft(session.id, session.revision, JSON.parse(sampleText) as unknown),
    onSuccess: setPreview,
    onError: error => toast.error("Could not preview", { description: error instanceof Error ? error.message : undefined }),
  })
  const editable = !locked && session.status !== "Published" && session.status !== "Abandoned"

  return <section className="min-w-0 space-y-4" aria-label="Workflow builder">
    <div className="flex flex-wrap items-center justify-between gap-2">
      <div><h3 className="text-lg font-semibold">{draft.title || "Untitled workflow"}</h3>
        <p className="text-sm text-muted-foreground">{dirty ? "Unsaved changes" : session.draft ? "Saved draft" : "No draft saved yet"} · revision {baseRevision}</p></div>
      <div className="flex gap-2">
        {dirty && <Button type="button" variant="outline" onClick={reset}>Discard edits</Button>}
        <Button type="button" disabled={!dirty || !editable || save.isPending || conflict}
          onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save draft"}</Button>
      </div>
    </div>
    {conflict && <div className="space-y-2 rounded-md border border-destructive p-3 text-sm" role="alert">
      <p className="font-medium">The saved chat changed while you were editing. Your edits are still here.</p>
      <p>Compare the saved draft with yours before replacing it. Current server revision: {session.revision}; your base: {baseRevision}.</p>
      <div className="flex flex-wrap gap-2">
        <Button type="button" size="sm" variant="outline" onClick={reset}>Use latest saved draft</Button>
        <Button type="button" size="sm" variant="outline" onClick={() => { setBaseRevision(session.revision); setConflict(false) }}>Keep my edits for review</Button>
      </div>
      <details><summary className="cursor-pointer">Compare JSON drafts</summary><div className="grid gap-2 lg:grid-cols-2">
        <pre className="max-h-60 overflow-auto rounded bg-muted p-2 text-xs">Saved: {JSON.stringify(session.draft, null, 2)}</pre>
        <pre className="max-h-60 overflow-auto rounded bg-muted p-2 text-xs">Your edits: {JSON.stringify(draft, null, 2)}</pre>
      </div></details>
    </div>}
    {session.validation?.errors?.length > 0 && <div className="rounded-md border border-destructive/40 p-3" role="status">
      <p className="font-medium text-destructive">Issues to resolve ({session.validation.errors.length})</p>
      <ul className="mt-2 space-y-1 text-sm">{session.validation.errors.map((issue, index) =>
        <li key={`${issue.path}-${index}`}><span className="font-medium">{issue.path}</span>: {issue.message}</li>)}</ul>
    </div>}
      <Tabs value={editorTab} onValueChange={setEditorTab} className="min-w-0">
        <TabsList aria-label="Workflow sections" className="grid !h-auto min-h-11 w-full grid-cols-3 gap-1 [&_button]:min-h-11 [&_button]:px-3 sm:flex sm:w-fit sm:flex-wrap">
          <TabsTrigger value="workflow">Canvas</TabsTrigger>
          <TabsTrigger value="details">Details</TabsTrigger><TabsTrigger value="inputs">Inputs</TabsTrigger>
          <TabsTrigger value="agents">Agents</TabsTrigger>
          <TabsTrigger value="settings">Settings</TabsTrigger><TabsTrigger value="preview">Preview</TabsTrigger>
        </TabsList>
        <TabsContent value="workflow" className="mt-4 min-w-0"><WorkflowBuilder draft={draft} capabilities={capabilities} models={modelsQuery.data ?? []}
          disabled={!editable || save.isPending} onChange={update} onEditAgents={() => setEditorTab("agents")} /></TabsContent>
        <fieldset disabled={!editable || save.isPending} className="min-w-0 disabled:opacity-60">
        <TabsContent value="details" className="mt-4 space-y-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <Field label="Preset key" value={draft.key} onChange={key => update({ ...draft, key })} />
            <Field label="Title" value={draft.title} onChange={title => update({ ...draft, title })} />
          </div>
          <Field label="Subtitle" value={draft.subtitle} onChange={subtitle => update({ ...draft, subtitle })} />
          <Field label="Description" value={draft.description} multiline onChange={description => update({ ...draft, description })} />
          <Field label="Detailed description" value={draft.detailedDescription} multiline onChange={detailedDescription => update({ ...draft, detailedDescription })} />
          <Choice label="Result contract" value={draft.resultContractKey ?? ""} options={[{ value: "arzly.report", label: "Arzly report v4" }]}
            onChange={key => update({ ...draft, resultContractKey: key || null, resultContractVersion: key ? 4 : null })} />
        </TabsContent>
        <TabsContent value="inputs" className="mt-4"><SchemaEditor value={draft.inputSchemaJson}
          onChange={inputSchemaJson => update({ ...draft, inputSchemaJson })}
          onRename={(oldKey, key, inputSchemaJson) => update(renameInput({ ...draft, inputSchemaJson }, oldKey, key))} /></TabsContent>
        <TabsContent value="agents" className="mt-4 space-y-4">
          {draft.agents.map((agent, index) => {
            const change = (next: typeof agent) => update({ ...draft, agents: draft.agents.map((old, i) => i === index ? next : old),
              workflow: { ...draft.workflow, nodes: draft.workflow.nodes.map(node => node.type === "Agent" && node.referenceKey === agent.key
                ? { ...node, referenceKey: next.key } : node) } })
            return <details key={index} className="rounded-md border p-3" open={draft.agents.length === 1 || undefined}>
              <summary className="cursor-pointer font-medium">{agent.name || agent.key || `Agent ${index + 1}`}</summary>
              <div className="mt-3 space-y-3">
                <div className="grid gap-3 sm:grid-cols-2"><Field label="Agent key" value={agent.key} onChange={key => change({ ...agent, key })} />
                  <Field label="Name" value={agent.name} onChange={name => change({ ...agent, name })} /></div>
                <Field label="Instructions" value={agent.instructions} multiline onChange={instructions => change({ ...agent, instructions })} />
                <Choice label="Runtime" value={enumName(agent.runtimeType, ["Model", "Passthrough"])}
                  options={["Model", "Passthrough"].map(value => ({ value, label: value }))}
                  onChange={runtimeType => change({ ...agent, runtimeType })} />
                <Choice label="Runtime model" value={`${agent.providerKey}:${agent.modelKey}`}
                  options={(modelsQuery.data ?? []).map(model => ({ value: `${model.provider}:${model.model}`, label: `${model.provider} / ${model.displayName}` }))}
                  onChange={value => { const separator = value.indexOf(":"); change({ ...agent,
                    providerKey: value.slice(0, separator), modelKey: value.slice(separator + 1) }) }} />
                {modelsQuery.isError && <p className="text-sm text-destructive">Could not load runtime models.</p>}
                <div className="grid gap-3 sm:grid-cols-3">
                  <Field label="Default temperature" type="number" value={agent.defaultTemperature} onChange={value => change({ ...agent, defaultTemperature: Number(value) })} />
                  <Field label="Minimum" type="number" value={agent.minimumTemperature} onChange={value => change({ ...agent, minimumTemperature: Number(value) })} />
                  <Field label="Maximum" type="number" value={agent.maximumTemperature} onChange={value => change({ ...agent, maximumTemperature: Number(value) })} />
                </div>
                <div className="grid gap-2 sm:grid-cols-2">
                  <Toggle label="Allow model override" value={agent.allowModelOverride} onChange={allowModelOverride => change({ ...agent, allowModelOverride })} />
                  <Toggle label="Allow temperature override" value={agent.allowTemperatureOverride} onChange={allowTemperatureOverride => change({ ...agent, allowTemperatureOverride })} />
                  {(["planningEnabled", "todoTrackingEnabled", "contextCompactionEnabled", "requireToolApproval", "webSearchEnabled"] as const)
                    .map(key => <Toggle key={key} label={key.replace(/([A-Z])/g, " $1")} value={agent.harness[key]}
                      onChange={value => change({ ...agent, harness: { ...agent.harness, [key]: value } })} />)}
                </div>
                <Field label="Max iterations" type="number" value={agent.harness.maxIterations}
                  onChange={value => change({ ...agent, harness: { ...agent.harness, maxIterations: Number(value) } })} />
                <JsonField label="Output schema JSON (optional)" value={agent.outputSchemaJson ?? "{}"}
                  onChange={outputSchemaJson => change({ ...agent, outputSchemaJson })} />
                <Button type="button" variant="destructive" size="sm" onClick={() => update({ ...draft, agents: draft.agents.filter((_, i) => i !== index) })}>Remove agent</Button>
              </div>
            </details>
          })}
          <Button type="button" variant="outline" onClick={() => update({ ...draft,
            agents: [...draft.agents, newAgent(uniqueKey("agent", draft.agents.map(agent => agent.key)))] })}>Add agent</Button>
        </TabsContent>
        <TabsContent value="settings" className="mt-4 space-y-4">
          <Choice label="Background execution" value={enumName(draft.backgroundExecution.mode, backgroundNames)}
            options={backgroundNames.map(value => ({ value, label: value }))}
            onChange={mode => update({ ...draft, backgroundExecution: { ...draft.backgroundExecution, mode } })} />
          <Field label="Background rationale" value={draft.backgroundExecution.rationale} multiline onChange={rationale => update({ ...draft,
            backgroundExecution: { ...draft.backgroundExecution, rationale } })} />
          <div className="flex flex-wrap gap-4">{["manual", "interval", "daily", "weekly"].map(trigger =>
            <Toggle key={trigger} label={trigger} value={draft.backgroundExecution.allowedTriggerTypes.includes(trigger)}
              onChange={checked => update({ ...draft, backgroundExecution: { ...draft.backgroundExecution,
                allowedTriggerTypes: checked ? [...draft.backgroundExecution.allowedTriggerTypes, trigger]
                  : draft.backgroundExecution.allowedTriggerTypes.filter(item => item !== trigger) } })} />)}</div>
          <h4 className="font-semibold">Admin notes</h4>
          {draft.adminNotes.map((note, index) => {
            const change = (next: typeof note) => update({ ...draft, adminNotes: draft.adminNotes.map((old, i) => i === index ? next : old) })
            return <div key={index} className="space-y-2 rounded-md border p-3">
              <Field label="Note title" value={note.title} onChange={title => change({ ...note, title })} />
              <Field label="Description" value={note.description} multiline onChange={description => change({ ...note, description })} />
              <Choice label="Severity" value={enumName(note.severity, severityNames)}
                options={severityNames.map(value => ({ value, label: value }))} onChange={severity => change({ ...note, severity })} />
              <Field label="Links (one per line)" value={note.links.join("\n")} multiline
                onChange={value => change({ ...note, links: value.split("\n").map(item => item.trim()).filter(Boolean) })} />
              <Button type="button" size="sm" variant="destructive" onClick={() => update({ ...draft, adminNotes: draft.adminNotes.filter((_, i) => i !== index) })}>Remove note</Button>
            </div>
          })}
          <Button type="button" variant="outline" onClick={() => update({ ...draft,
            adminNotes: [...draft.adminNotes, { title: "", description: "", severity: "Information", links: [] }] })}>Add note</Button>
        </TabsContent>
        </fieldset>
        <TabsContent value="preview" className="mt-4 space-y-3">
          <p className="text-sm text-muted-foreground">Dry run the saved draft. Provider and integration steps are shown without execution.</p>
          <JsonField label="Sample inputs JSON" value={sampleText} onChange={setSampleText} />
          <Button type="button" disabled={dirty || !session.draft || runPreview.isPending || session.turn?.status === "Running"}
            onClick={() => runPreview.mutate()}>{runPreview.isPending ? "Previewing…" : "Run preview"}</Button>
          {dirty && <p className="text-sm text-muted-foreground">Save your edits to preview them.</p>}
          {preview && <div className="space-y-3" role="status">
            <p className="font-medium">Execution plan · draft {preview.draftRevision}</p>
            {preview.validation.errors.map((issue, index) => <p key={index} className="text-sm text-destructive">{issue.path}: {issue.message}</p>)}
            <ol className="space-y-2">{preview.nodes.map(node => <li key={node.key} className="rounded-md border p-3 text-sm">
              <p className="font-medium">{node.name} · {node.type}</p>
              {node.inputs.map(input => <p key={input.input}>{input.input}: {input.status === "RequiresExecution"
                ? `${input.source} (requires execution)` : input.status === "Resolved" || input.status === "Optional"
                  ? JSON.stringify(input.value) : `${input.source} (unresolved)`}</p>)}
            </li>)}</ol>
          </div>}
        </TabsContent>
      </Tabs>
  </section>
}
