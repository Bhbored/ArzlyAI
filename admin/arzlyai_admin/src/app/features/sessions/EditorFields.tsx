import { useId } from "react"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"

export function Field({ label, value, onChange, multiline = false, type = "text" }: {
  label: string; value: string | number; onChange: (value: string) => void; multiline?: boolean; type?: string
}) {
  const id = useId()
  return <div className="space-y-1"><label htmlFor={id} className="text-sm font-medium">{label}</label>
    {multiline ? <Textarea id={id} value={value} onChange={event => onChange(event.target.value)} className="min-h-24" />
      : <Input id={id} type={type} value={value} onChange={event => onChange(event.target.value)} />}
  </div>
}

export function Choice({ label, value, options, onChange }: {
  label: string; value: string; options: { value: string; label: string }[]; onChange: (value: string) => void
}) {
  const id = useId()
  return <div className="space-y-1"><label htmlFor={id} className="text-sm font-medium">{label}</label>
    <select id={id} value={value} onChange={event => onChange(event.target.value)}
      className="h-10 w-full rounded-md border border-input bg-background px-3 text-sm focus-visible:outline-2 focus-visible:outline-ring">
      <option value="">Choose…</option>
      {value && !options.some(option => option.value === value) && <option value={value}>{value} (unavailable)</option>}
      {options.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}
    </select>
  </div>
}

export function Toggle({ label, value, onChange }: { label: string; value: boolean; onChange: (value: boolean) => void }) {
  return <label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={value}
    onChange={event => onChange(event.target.checked)} className="size-4 accent-primary" />{label}</label>
}

export function JsonField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  let error = ""
  try { JSON.parse(value) } catch { error = "Enter valid JSON before validating or publishing." }
  return <div><Field label={label} value={value} onChange={onChange} multiline />
    {error && <p className="mt-1 text-sm text-destructive" role="status">{error}</p>}</div>
}
