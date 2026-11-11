import { Button } from "@/components/ui/button"
import { Choice, Field, JsonField, Toggle } from "./EditorFields"
import { uniqueKey } from "./draftEditorModel"

type Schema = { type?: string; properties?: Record<string, { type?: string; description?: string; [key: string]: unknown }>; required?: string[]; [key: string]: unknown }

export function SchemaEditor({ value, onChange, onRename }: { value: string; onChange: (value: string) => void; onRename?: (oldKey: string, newKey: string, value: string) => void }) {
  let schema: Schema | null = null
  try {
    const parsed = JSON.parse(value)
    if (parsed && typeof parsed === "object" && !Array.isArray(parsed) &&
      (!parsed.properties || typeof parsed.properties === "object")) schema = parsed
  } catch { /* The JSON field below preserves incomplete schemas. */ }
  const current = schema
  const save = (next: Schema) => onChange(JSON.stringify(next, null, 2))
  return <div className="space-y-4">
    {current && <>
      {Object.entries(current.properties ?? {}).map(([name, property], index) => <div key={index} className="space-y-3 rounded-md border p-3">
        <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Input name" value={name} onChange={key => {
            if (key !== name && Object.hasOwn(current.properties ?? {}, key)) return
            const next = { ...current, properties: Object.fromEntries(Object.entries(current.properties ?? {}).map(([keyBefore, item]) => [keyBefore === name ? key : keyBefore, item])),
              required: (current.required ?? []).map(keyBefore => keyBefore === name ? key : keyBefore) }
            if (onRename) onRename(name, key, JSON.stringify(next, null, 2))
            else save(next)
          }} />
          <Choice label="Type" value={property.type ?? "string"} options={["string", "number", "integer", "boolean", "array", "object"].map(type => ({ value: type, label: type }))}
            onChange={type => save({ ...current, properties: { ...current.properties, [name]: { ...property, type } } })} />
        </div>
        <Field label="Help text" value={property.description ?? ""} onChange={description => save({ ...current, properties: { ...current.properties, [name]: { ...property, description } } })} />
        <div className="flex items-center justify-between gap-3">
          <Toggle label="Required input" value={(current.required ?? []).includes(name)} onChange={checked => save({ ...current,
            required: checked ? [...(current.required ?? []), name] : (current.required ?? []).filter(key => key !== name) })} />
          <Button type="button" variant="outline" size="sm" onClick={() => save({ ...current,
            properties: Object.fromEntries(Object.entries(current.properties ?? {}).filter(([key]) => key !== name)),
            required: (current.required ?? []).filter(key => key !== name) })}>Remove input</Button>
        </div>
      </div>)}
      <Button type="button" variant="outline" onClick={() => save({ ...current, type: "object", properties: {
        ...current.properties, [uniqueKey("input", Object.keys(current.properties ?? {}))]: { type: "string", description: "" },
      } })}>Add input</Button>
    </>}
    <details open={!current}><summary className="cursor-pointer text-sm font-medium">Advanced JSON schema</summary>
      <div className="mt-3"><JsonField label="Input schema JSON" value={value} onChange={onChange} /></div>
    </details>
  </div>
}

export function MappingEditor({ value, sources, onChange, requiredFields = [] }: { value: string; sources: string[]; onChange: (value: string) => void; requiredFields?: string[] }) {
  let mappings: Record<string, string> | null = null
  try {
    const parsed = JSON.parse(value)
    if (parsed && typeof parsed === "object" && !Array.isArray(parsed) && Object.values(parsed).every(item => typeof item === "string")) mappings = parsed
  } catch { /* Invalid mapping text remains editable below. */ }
  const current = mappings
  const save = (next: Record<string, string>) => onChange(JSON.stringify(next, null, 2))
  return <div className="space-y-3">
    <p className="text-sm text-muted-foreground">Connect each step input to a preset input, a previous step, or a literal value.</p>
    {current && requiredFields.some(name => !(name in current)) && <Button type="button" variant="outline" className="min-h-11"
      onClick={() => save({ ...Object.fromEntries(requiredFields.map(name => [name, sources.includes(`$.inputs.${name}`) ? `$.inputs.${name}` : ""])), ...current })}>Add required mappings</Button>}
    {current && Object.entries(current).map(([name, source], index) => <div key={index} className="space-y-2 rounded-md border p-3">
      <Field label="Step input" value={name} onChange={key => {
        if (key !== name && Object.hasOwn(current, key)) return
        save(Object.fromEntries(Object.entries(current).map(([old, path]) => [old === name ? key : old, path])))
      }} />
      <Choice label="Use a known source" value={sources.includes(source) ? source : ""} options={sources.map(path => ({ value: path, label: path }))}
        onChange={path => save({ ...current, [name]: path })} />
      <Field label="Source path or $.literal.value" value={source} onChange={path => save({ ...current, [name]: path })} />
      <Button type="button" variant="outline" size="sm" onClick={() => save(Object.fromEntries(Object.entries(current).filter(([key]) => key !== name)))}>Remove mapping</Button>
    </div>)}
    {current && <Button type="button" variant="outline" onClick={() => save({ ...current, [uniqueKey("input", Object.keys(current))]: "" })}>Add mapping</Button>}
    <details open={!current}><summary className="cursor-pointer text-sm">Mapping JSON</summary>
      <JsonField label="Input mapping JSON" value={value} onChange={onChange} />
    </details>
  </div>
}
