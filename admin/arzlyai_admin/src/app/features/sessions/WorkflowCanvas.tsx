import { useState } from "react"
import { ReactFlow, Controls, Background, Handle, Position, MarkerType,
  type Node, type NodeChange, type NodeProps, type ReactFlowInstance } from "@xyflow/react"
import { BrainCircuit, Plug, SlidersHorizontal, UserCheck } from "lucide-react"
import "@xyflow/react/dist/style.css"
import type { PresetDraft } from "../../shared/types"
import { canConnectWorkflow, enumName, nodeTypes } from "./draftEditorModel"

type StepNode = Node<{ label: string; kind: string; reference: string; index: number }, "step">
const icons = { Agent: BrainCircuit, HumanApproval: UserCheck, Integration: Plug, Operation: SlidersHorizontal }

function WorkflowStep({ data, selected, isConnectable }: NodeProps<StepNode>) {
  const Icon = icons[data.kind as keyof typeof icons] ?? SlidersHorizontal
  return <div className={`w-60 rounded-xl border-2 bg-card p-4 text-foreground shadow-sm ${selected ? "border-primary" : "border-muted-foreground"}`}>
    <Handle type="target" position={Position.Left} isConnectable={isConnectable} aria-label="Input connection" className="!size-3 !border-2 !border-card !bg-primary" />
    <div className="mb-3 flex items-center justify-between gap-2 text-xs text-muted-foreground">
      <span className="flex items-center gap-2"><Icon className="size-4" />{data.kind === "HumanApproval" ? "Human review" : data.kind === "Operation" ? "Processing" : data.kind}</span>
      <span>{String(data.index + 1).padStart(2, "0")}</span>
    </div>
    <p className="break-words text-sm font-semibold">{data.label}</p>
    <p className="mt-1 break-words text-xs text-muted-foreground">{data.reference || (data.kind === "HumanApproval" ? "Pause for approval" : "Choose a component")}</p>
    <Handle type="source" position={Position.Right} isConnectable={isConnectable} aria-label="Output connection" className="!size-3 !border-2 !border-card !bg-primary" />
  </div>
}

const canvasNodeTypes = { step: WorkflowStep }
export const componentDragType = "application/arzly-workflow-component"

export function WorkflowCanvas({ draft, disabled, selected, onSelect, onChange, onAdd }: {
  draft: PresetDraft; disabled: boolean; selected: string | null
  onSelect: (key: string) => void; onChange: (draft: PresetDraft) => void
  onAdd: (componentId: string, position: { x: number; y: number }) => void
}) {
  const [positions, setPositions] = useState<Record<string, { x: number; y: number }>>({})
  const [measurements, setMeasurements] = useState<Record<string, { width: number; height: number }>>({})
  const [flow, setFlow] = useState<ReactFlowInstance<StepNode> | null>(null)
  const nodes: StepNode[] = draft.workflow.nodes.map((node, index) => ({
    id: node.key, type: "step", selected: selected === node.key,
    measured: measurements[node.key],
    position: positions[node.key] ?? node.editorPosition ?? { x: (index % 3) * 310 + 30, y: Math.floor(index / 3) * 190 + 40 },
    data: { label: node.displayName || node.key, kind: enumName(node.type, nodeTypes), reference: node.referenceKey, index },
  }))
  const edges = draft.workflow.connections.map((edge, index) => ({
    id: `${index}:${edge.sourceNodeKey}:${edge.targetNodeKey}`, source: edge.sourceNodeKey, target: edge.targetNodeKey,
    type: "smoothstep", style: { stroke: "var(--muted-foreground)", strokeWidth: 2 },
    markerEnd: { type: MarkerType.ArrowClosed, color: "var(--muted-foreground)" },
  }))
  const onNodesChange = (changes: NodeChange<StepNode>[]) => {
    if (changes.some(change => change.type === "position")) setPositions(previous => {
      const next = { ...previous }
      for (const change of changes) if (change.type === "position" && change.position) next[change.id] = change.position
      return next
    })
    if (changes.some(change => change.type === "dimensions")) setMeasurements(previous => {
      const next = { ...previous }
      for (const change of changes) if (change.type === "dimensions" && change.dimensions) next[change.id] = change.dimensions
      return next
    })
  }
  return <div className="relative h-[28rem] min-w-0 rounded-lg border bg-background xl:h-[38rem]" aria-label="Workflow canvas">
    <ReactFlow nodes={nodes} edges={edges} nodeTypes={canvasNodeTypes} onNodesChange={onNodesChange} onInit={setFlow}
      onNodeClick={(_event, node) => onSelect(node.id)}
      onNodeDragStop={(_event, node) => {
        if (disabled) return
        onChange({ ...draft, workflow: { ...draft.workflow, nodes: draft.workflow.nodes.map(item => item.key === node.id
          ? { ...item, editorPosition: node.position } : item) } })
        setPositions({})
      }}
      onDragOver={event => { if (!disabled) { event.preventDefault(); event.dataTransfer.dropEffect = "move" } }}
      onDrop={event => {
        event.preventDefault()
        if (disabled || !flow) return
        const componentId = event.dataTransfer.getData(componentDragType)
        if (componentId) onAdd(componentId, flow.screenToFlowPosition({ x: event.clientX, y: event.clientY }))
      }}
      isValidConnection={connection => canConnectWorkflow(draft, connection.source, connection.target)}
      onConnect={connection => {
        if (disabled || !canConnectWorkflow(draft, connection.source, connection.target)) return
        onChange({ ...draft, workflow: { ...draft.workflow, connections: [...draft.workflow.connections,
          { sourceNodeKey: connection.source, targetNodeKey: connection.target }] } })
      }}
      nodesDraggable={!disabled} nodesConnectable={!disabled} deleteKeyCode={null} fitView minZoom={0.2} maxZoom={1.5}
      fitViewOptions={{ padding: 0.25, maxZoom: 1 }}
      ariaLabelConfig={{ "controls.ariaLabel": "Canvas controls" }}>
      <Background color="var(--border)" gap={24} /><Controls showInteractive={false} className="!bg-card [&_button]:!border-border [&_button]:!bg-card [&_button]:!fill-foreground" />
    </ReactFlow>
    {nodes.length === 0 && <div className="pointer-events-none absolute inset-0 flex items-center justify-center p-8">
      <div className="max-w-xs text-center"><BrainCircuit className="mx-auto mb-4 size-9 text-primary" />
        <p className="font-semibold">Build your workflow</p><p className="mt-2 text-sm text-muted-foreground">Drag a component onto the canvas, or select it from the library. Connect steps to define the flow.</p>
      </div>
    </div>}
  </div>
}
