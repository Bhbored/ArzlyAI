import { useState } from "react"
import { BrainCircuit, GripVertical, Plug, SlidersHorizontal, UserCheck } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import type { Capability, PresetDraft, PresetDraftNode, RuntimeModel } from "../../shared/types"
import { Choice, Field, JsonField, Toggle } from "./EditorFields"
import { MappingEditor } from "./SchemaEditor"
import { WorkflowCanvas, componentDragType } from "./WorkflowCanvas"
import { appendWorkflowStep, canConnectWorkflow, enumName, nodeTypes, removeNode, renameNode, upstreamNodeKeys, type WorkflowComponent } from "./draftEditorModel"

export function WorkflowBuilder({ draft, capabilities, models, disabled, onChange, onEditAgents }: {
  draft: PresetDraft; capabilities: Capability[]; models: RuntimeModel[]; disabled: boolean
  onChange: (draft: PresetDraft) => void; onEditAgents: () => void
}) {
  const [search, setSearch] = useState("")
  const [selectedKey, setSelectedKey] = useState<string | null>(null)
  const [source, setSource] = useState("")
  const [target, setTarget] = useState("")
  const components: WorkflowComponent[] = [
    { id: "new-agent", type: "Agent", referenceKey: "", name: "AI agent", description: "Reason, write, or transform with a model." },
    { id: "human-review", type: "HumanApproval", referenceKey: "", name: "Human review", description: "Pause for a person to review the result." },
    ...draft.agents.map(agent => ({ id: `agent:${agent.key}`, type: "Agent", referenceKey: agent.key, name: agent.name || agent.key, description: "Reuse an agent from this workflow." })),
    ...capabilities.map(item => ({ id: `${item.kind}:${item.key}`, type: item.kind, referenceKey: item.key, name: item.displayName, description: item.description })),
  ]
  const add = (id: string, position?: { x: number; y: number }) => {
    const component = components.find(item => item.id === id)
    if (!component || disabled) return
    const next = appendWorkflowStep(draft, component, position, models[0])
    onChange(next); setSelectedKey(next.workflow.nodes.at(-1)!.key)
  }
  const selected = draft.workflow.nodes.find(node => node.key === selectedKey)
  const selectedType = selected ? enumName(selected.type, nodeTypes) : ""
  const capability = capabilities.find(item => item.key === selected?.referenceKey && item.kind === selectedType)
  const agent = draft.agents.find(item => item.key === selected?.referenceKey && selectedType === "Agent")
  const changeNode = (next: PresetDraftNode) => {
    if (!selected || disabled) return
    const renamed = next.key !== selected.key ? renameNode(draft, selected.key, next.key) : draft
    onChange({ ...renamed, workflow: { ...renamed.workflow, nodes: renamed.workflow.nodes.map(node => node.key === next.key ? next : node) } })
    setSelectedKey(next.key)
  }
  let inputs: string[] = []
  let required: string[] = []
  try { inputs = Object.keys(JSON.parse(draft.inputSchemaJson).properties ?? {}) } catch { /* Advanced JSON may be incomplete. */ }
  try { required = JSON.parse(capability?.inputSchemaJson ?? "{}").required ?? [] } catch { /* Keep the raw schema available below. */ }
  const ancestors = upstreamNodeKeys(draft, selectedKey ?? "")
  const sources = [...inputs.flatMap(key => [`$.inputs.${key}`, `$.inputs.${key}?`]),
    ...draft.workflow.nodes.filter(node => ancestors.has(node.key)).flatMap(node => [
      `$.nodes.${node.key}.output`, ...(enumName(node.type, nodeTypes) === "HumanApproval" ? [`$.nodes.${node.key}.approvedOutput`] : []),
    ])]
  const references = selectedType === "Agent" ? draft.agents.map(item => ({ value: item.key, label: item.name || item.key }))
    : capabilities.filter(item => item.kind === selectedType).map(item => ({ value: item.key, label: item.displayName }))
  const visible = components.filter(item => `${item.name} ${item.description} ${item.referenceKey}`.toLowerCase().includes(search.toLowerCase()))
  const stepOptions = draft.workflow.nodes.map(node => ({ value: node.key, label: node.displayName || node.key }))
  return <div className="space-y-4">
    <div className="flex flex-wrap items-center justify-between gap-3">
      <div><h4 className="font-semibold">Workflow canvas</h4><p className="mt-1 text-sm text-muted-foreground">Add components, connect steps, and select a step to configure it.</p></div>
      <span className="text-sm text-muted-foreground">{draft.workflow.nodes.length} steps · {draft.workflow.connections.length} connections</span>
    </div>
    <div className="grid min-w-0 gap-3 md:grid-cols-[11rem_minmax(0,1fr)] xl:grid-cols-[12rem_minmax(0,1fr)_18rem]">
      <aside className="min-w-0 rounded-lg border bg-card p-3" aria-label="Component library">
        <h5 className="mb-2 text-sm font-semibold">Components</h5>
        <Input value={search} onChange={event => setSearch(event.target.value)} placeholder="Search components" aria-label="Search components" className="mb-3" />
        <div className="max-h-64 space-y-4 overflow-y-auto pr-1 md:max-h-[32rem]">
          {[{ type: "Agent", title: "Agents", Icon: BrainCircuit }, { type: "HumanApproval", title: "Review", Icon: UserCheck },
            { type: "Integration", title: "Integrations", Icon: Plug }, { type: "Operation", title: "Processing steps", Icon: SlidersHorizontal }].map(({ type, title, Icon }) => {
            const items = visible.filter(item => item.type === type)
            return items.length > 0 && <div key={type}><p className="mb-2 text-xs font-medium text-muted-foreground">{title}</p>
              <div className="grid gap-2 sm:grid-cols-2 md:grid-cols-1">{items.map(item => <button key={item.id} type="button" disabled={disabled}
                draggable={!disabled} onDragStart={event => { event.dataTransfer.setData(componentDragType, item.id); event.dataTransfer.effectAllowed = "move" }}
                onClick={() => add(item.id)} title={item.description} aria-label={`Add ${item.name}`}
                className="flex min-h-12 w-full items-start gap-2 rounded-md border border-muted-foreground bg-background p-3 text-left text-sm transition-colors hover:border-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-ring disabled:opacity-50">
                <Icon className="mt-0.5 size-4 shrink-0 text-primary" /><span className="min-w-0 flex-1 break-words">{item.name}</span><GripVertical className="mt-0.5 size-3 shrink-0 text-muted-foreground" />
              </button>)}</div></div>
          })}
          {visible.length === 0 && <p className="text-sm text-muted-foreground">No components match your search.</p>}
        </div>
        <p className="mt-3 text-xs text-muted-foreground">Drag onto the canvas or click to add.</p>
      </aside>
      <div className="min-w-0"><WorkflowCanvas draft={draft} selected={selectedKey} onSelect={setSelectedKey} disabled={disabled} onChange={onChange} onAdd={add} />
        {draft.workflow.nodes.length > 0 && <div className="mt-3 flex flex-wrap gap-2" aria-label="Select a workflow step">
          {draft.workflow.nodes.map(node => <Button key={node.key} type="button" variant={node.key === selectedKey ? "secondary" : "outline"}
            className="h-auto min-h-11 max-w-full whitespace-normal" onClick={() => setSelectedKey(node.key)}>{node.displayName || node.key}</Button>)}
        </div>}
      </div>
      <aside className="min-w-0 rounded-lg border bg-card p-4 md:col-span-2 xl:col-span-1" aria-label="Step settings">
        <h5 className="mb-4 font-semibold">{selected ? "Step settings" : "Select a step"}</h5>
        {!selected ? <p className="text-sm text-muted-foreground">Choose a step on the canvas to set its inputs, model, instructions, or integration.</p>
          : <fieldset disabled={disabled} className="min-w-0 space-y-4 xl:max-h-[34rem] xl:overflow-y-auto xl:pr-1">
            <Field label="Step name" value={selected.displayName} onChange={displayName => changeNode({ ...selected, displayName })} />
            <p className="text-xs text-muted-foreground">{selectedType === "Operation" ? "Processing step" : selectedType === "HumanApproval" ? "Human review" : selectedType}</p>
            {selectedType !== "HumanApproval" && <Choice label={selectedType === "Agent" ? "Agent" : "Component"} value={selected.referenceKey} options={references}
              onChange={referenceKey => changeNode({ ...selected, referenceKey })} />}
            {agent && <>
              <Field label="Agent instructions" value={agent.instructions} multiline onChange={instructions => onChange({ ...draft,
                agents: draft.agents.map(item => item.key === agent.key ? { ...item, instructions } : item) })} />
              <Choice label="Agent model" value={`${agent.providerKey}:${agent.modelKey}`} options={models.map(model => ({ value: `${model.provider}:${model.model}`, label: `${model.provider} / ${model.displayName}` }))}
                onChange={value => { const index = value.indexOf(":"); onChange({ ...draft, agents: draft.agents.map(item => item.key === agent.key
                  ? { ...item, providerKey: value.slice(0, index), modelKey: value.slice(index + 1) } : item) }) }} />
              <Button type="button" variant="outline" className="min-h-11" onClick={onEditAgents}>All agent settings</Button>
            </>}
            {capability && <div className="space-y-2 rounded-md bg-muted p-3 text-sm">
              <p>{capability.description}</p><p className="text-muted-foreground">{capability.connectorKey ? `Connection: ${capability.connectorKey}. ` : ""}Risk: {capability.riskLevel}.</p>
              {required.length > 0 && <p className="break-words">Required inputs: {required.join(", ")}</p>}
            </div>}
            {selectedType === "HumanApproval" && <p className="text-sm text-muted-foreground">Connect an upstream agent whose result a person will review before the workflow continues.</p>}
            <h6 className="text-sm font-semibold">Inputs and mappings</h6>
            <MappingEditor value={selected.inputMappingJson} sources={sources} requiredFields={required} onChange={inputMappingJson => changeNode({ ...selected, inputMappingJson })} />
            <Toggle label="Require human approval" value={selected.requiresHumanApproval} onChange={requiresHumanApproval => changeNode({ ...selected, requiresHumanApproval })} />
            <details><summary className="cursor-pointer py-2 text-sm font-medium">Advanced step settings</summary><div className="mt-2 space-y-3">
              <Field label="Step key" value={selected.key} onChange={key => {
                if (key !== selected.key && draft.workflow.nodes.some(node => node.key === key)) return
                changeNode({ ...selected, key })
              }} />
              <Field label="Execution position" type="number" value={selected.position} onChange={value => changeNode({ ...selected, position: Number(value) })} />
              <JsonField label="Configuration JSON" value={selected.configurationJson ?? "{}"} onChange={configurationJson => changeNode({ ...selected, configurationJson })} />
              <Choice label="Step result contract" value={selected.resultContractKey ?? ""} options={[{ value: "arzly.report", label: "Arzly report v4" }]}
                onChange={key => changeNode({ ...selected, resultContractKey: key || null, resultContractVersion: key ? 4 : null })} />
            </div></details>
            <Button type="button" variant="destructive" className="min-h-11" onClick={() => { onChange(removeNode(draft, selected.key)); setSelectedKey(null) }}>Remove step</Button>
          </fieldset>}
      </aside>
    </div>
    <details className="rounded-lg border bg-card p-4"><summary className="cursor-pointer text-sm font-semibold">Connections and workflow settings</summary>
      <fieldset disabled={disabled} className="mt-4 min-w-0 space-y-3">
        <Field label="Workflow key" value={draft.workflow.key} onChange={key => onChange({ ...draft, workflow: { ...draft.workflow, key } })} />
        <p className="text-sm text-muted-foreground">Connect nodes on the canvas or use these controls. Connections cannot form a loop.</p>
        {draft.workflow.connections.map((edge, index) => <div key={`${edge.sourceNodeKey}:${edge.targetNodeKey}`} className="flex items-center justify-between gap-2 text-sm">
          <span className="min-w-0 break-words">{edge.sourceNodeKey} → {edge.targetNodeKey}</span><Button type="button" variant="outline" className="min-h-11 shrink-0"
            onClick={() => onChange({ ...draft, workflow: { ...draft.workflow, connections: draft.workflow.connections.filter((_, i) => i !== index) } })}>Remove connection</Button>
        </div>)}
        <div className="grid gap-3 sm:grid-cols-[1fr_1fr_auto]">
          <Choice label="From step" value={source} options={stepOptions} onChange={setSource} />
          <Choice label="To step" value={target} options={stepOptions} onChange={setTarget} />
          <Button type="button" className="min-h-11 self-end" disabled={!canConnectWorkflow(draft, source, target)}
            onClick={() => onChange({ ...draft, workflow: { ...draft.workflow, connections: [...draft.workflow.connections, { sourceNodeKey: source, targetNodeKey: target }] } })}>Connect steps</Button>
        </div>
      </fieldset>
    </details>
  </div>
}
