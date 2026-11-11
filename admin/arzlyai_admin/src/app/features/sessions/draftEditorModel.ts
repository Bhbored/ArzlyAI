import type { PresetDraft, PresetDraftAgent, PresetDraftNode } from "../../shared/types"

export function emptyDraft(): PresetDraft {
  return {
    key: "", title: "", subtitle: "", description: "", detailedDescription: "",
    inputSchemaJson: '{"type":"object","properties":{},"required":[]}',
    resultContractKey: null, resultContractVersion: null,
    backgroundExecution: { mode: "NotApplicable", rationale: "", allowedTriggerTypes: ["manual"] },
    agents: [], workflow: { key: "workflow", nodes: [], connections: [] }, adminNotes: [],
  }
}

export function newAgent(key: string): PresetDraftAgent {
  return { key, name: "New agent", instructions: "", runtimeType: "Model", providerKey: "", modelKey: "",
    defaultTemperature: 0.7, minimumTemperature: 0, maximumTemperature: 1,
    allowModelOverride: false, allowTemperatureOverride: false, outputSchemaJson: null,
    harness: { planningEnabled: false, todoTrackingEnabled: false, contextCompactionEnabled: false,
      requireToolApproval: true, maxIterations: 5, webSearchEnabled: false } }
}

export function newNode(key: string, position: number): PresetDraftNode {
  return { key, displayName: "New step", type: "Agent", referenceKey: "", position,
    inputMappingJson: "{}", requiresHumanApproval: false, configurationJson: null,
    resultContractKey: null, resultContractVersion: null }
}

export function uniqueKey(prefix: string, existing: string[]) {
  let index = 1
  while (existing.includes(`${prefix}-${index}`)) index++
  return `${prefix}-${index}`
}

export const nodeTypes = ["Agent", "HumanApproval", "Integration", "Operation"]

export interface WorkflowComponent {
  id: string
  type: string
  referenceKey: string
  name: string
  description: string
}

export function appendWorkflowStep(draft: PresetDraft, component: WorkflowComponent,
  editorPosition?: { x: number; y: number }, model?: { provider: string; model: string }) {
  const key = uniqueKey("step", draft.workflow.nodes.map(node => node.key))
  const node = { ...newNode(key, Math.max(-1, ...draft.workflow.nodes.map(item => item.position)) + 1),
    type: component.type, displayName: component.name, referenceKey: component.referenceKey, editorPosition }
  let agents = draft.agents
  if (component.type === "Agent" && !component.referenceKey) {
    const agent = newAgent(uniqueKey("agent", agents.map(item => item.key)))
    if (model) { agent.providerKey = model.provider; agent.modelKey = model.model }
    node.referenceKey = agent.key
    agents = [...agents, agent]
  }
  return { ...draft, agents, workflow: { ...draft.workflow, nodes: [...draft.workflow.nodes, node] } }
}

export function canConnectWorkflow(draft: PresetDraft, source: string, target: string) {
  const keys = new Set(draft.workflow.nodes.map(node => node.key))
  if (!keys.has(source) || !keys.has(target) || source === target || draft.workflow.connections.some(edge =>
    edge.sourceNodeKey === source && edge.targetNodeKey === target)) return false
  const queue = [target]
  const visited = new Set<string>()
  while (queue.length) {
    const key = queue.pop()!
    if (key === source) return false
    if (visited.has(key)) continue
    visited.add(key)
    queue.push(...draft.workflow.connections.filter(edge => edge.sourceNodeKey === key).map(edge => edge.targetNodeKey))
  }
  return true
}

export function upstreamNodeKeys(draft: PresetDraft, target: string) {
  const visited = new Set<string>()
  const queue = [target]
  while (queue.length) {
    const key = queue.pop()!
    for (const edge of draft.workflow.connections.filter(item => item.targetNodeKey === key)) {
      if (edge.sourceNodeKey === target || visited.has(edge.sourceNodeKey)) continue
      visited.add(edge.sourceNodeKey); queue.push(edge.sourceNodeKey)
    }
  }
  return visited
}
export function enumName(value: number | string, names: string[]) {
  return typeof value === "number" ? names[value] ?? String(value) : value
}

export function renameNode(draft: PresetDraft, oldKey: string, key: string): PresetDraft {
  const nodes = draft.workflow.nodes.map(node => {
    let mappings = node.inputMappingJson
    try {
      const values = JSON.parse(mappings) as Record<string, unknown>
      for (const name of Object.keys(values)) {
        if (values[name] === `$.nodes.${oldKey}.output`) values[name] = `$.nodes.${key}.output`
        if (values[name] === `$.nodes.${oldKey}.approvedOutput`) values[name] = `$.nodes.${key}.approvedOutput`
      }
      mappings = JSON.stringify(values, null, 2)
    } catch { /* Preserve invalid text for correction in the editor. */ }
    return { ...node, key: node.key === oldKey ? key : node.key, inputMappingJson: mappings }
  })
  return { ...draft, workflow: { ...draft.workflow, nodes, connections: draft.workflow.connections.map(edge => ({
    sourceNodeKey: edge.sourceNodeKey === oldKey ? key : edge.sourceNodeKey,
    targetNodeKey: edge.targetNodeKey === oldKey ? key : edge.targetNodeKey,
  })) } }
}

export function renameInput(draft: PresetDraft, oldKey: string, key: string): PresetDraft {
  return { ...draft, workflow: { ...draft.workflow, nodes: draft.workflow.nodes.map(node => {
    let inputMappingJson = node.inputMappingJson
    try {
      const mappings = JSON.parse(inputMappingJson) as Record<string, unknown>
      for (const name of Object.keys(mappings)) {
        if (mappings[name] === `$.inputs.${oldKey}`) mappings[name] = `$.inputs.${key}`
        if (mappings[name] === `$.inputs.${oldKey}?`) mappings[name] = `$.inputs.${key}?`
      }
      inputMappingJson = JSON.stringify(mappings, null, 2)
    } catch { /* Keep invalid JSON available for manual correction. */ }
    return { ...node, inputMappingJson }
  }) } }
}

export function removeNode(draft: PresetDraft, key: string): PresetDraft {
  return { ...draft, workflow: { ...draft.workflow,
    nodes: draft.workflow.nodes.filter(node => node.key !== key),
    connections: draft.workflow.connections.filter(edge => edge.sourceNodeKey !== key && edge.targetNodeKey !== key),
  } }
}
