import { useMemo, useState } from "react"
import { useQuery } from "@tanstack/react-query"
import { Button } from "@/components/ui/button"
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Skeleton } from "@/components/ui/skeleton"
import { PageHeader } from "../../shared/components/PageHeader"
import { DataTableShell } from "../../shared/components/DataTableShell"
import type { Capability } from "../../shared/types"
import { capabilityQueries } from "./capabilities.service"

export default function CapabilitiesPage() {
  const capabilitiesQuery = useQuery(capabilityQueries.list())
  const [selected, setSelected] = useState<Capability | null>(null)

  const capabilities = useMemo(
    () => (capabilitiesQuery.data ?? []).filter(item => item.kind === "Integration"),
    [capabilitiesQuery.data],
  )

  return (
    <div className="space-y-6">
      <PageHeader
        title="Integrations"
        description="Services your workflows can connect to. Review their inputs, permissions, and external actions."
      />

      <DataTableShell title="Available integrations">
        {capabilitiesQuery.isPending ? (
          <div className="space-y-2 p-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : capabilitiesQuery.isError ? (
          <div className="p-6 text-sm text-destructive">Could not load integrations. <Button type="button" variant="outline" size="sm" onClick={() => void capabilitiesQuery.refetch()}>Retry</Button></div>
        ) : capabilities.length === 0 ? (
          <p className="p-6 text-sm text-muted-foreground">
            No integrations are registered.
          </p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Key</TableHead>
                <TableHead>Name</TableHead>
                <TableHead>Risk</TableHead>
                <TableHead>Background</TableHead>
                <TableHead className="w-24" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {capabilities.map((capability) => (
                <TableRow key={capability.key}>
                  <TableCell className="font-medium text-primary">
                    {capability.key}
                  </TableCell>
                  <TableCell>{capability.displayName}</TableCell>
                  <TableCell>{capability.riskLevel}</TableCell>
                  <TableCell>
                    {capability.supportsBackgroundExecution ? "Yes" : "No"}
                  </TableCell>
                  <TableCell>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => setSelected(capability)}
                    >
                      Details
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </DataTableShell>

      <Sheet
        open={selected !== null}
        onOpenChange={(open) => {
          if (!open) setSelected(null)
        }}
      >
        <SheetContent className="overflow-y-auto sm:max-w-lg">
          {selected ? (
            <>
              <SheetHeader>
                <SheetTitle>{selected.displayName}</SheetTitle>
                <SheetDescription>{selected.key}</SheetDescription>
              </SheetHeader>
              <div className="space-y-4 px-4 pb-6 text-sm">
                <p className="text-muted-foreground">{selected.description}</p>
                <Detail label="Kind" value={selected.kind} />
                <Detail
                  label="Connector"
                  value={selected.connectorKey ?? "—"}
                />
                <Detail label="Risk" value={selected.riskLevel} />
                <Detail
                  label="Background"
                  value={
                    selected.supportsBackgroundExecution ? "Supported" : "No"
                  }
                />
                <SchemaBlock label="Input schema" json={selected.inputSchemaJson} />
                <SchemaBlock
                  label="Output schema"
                  json={selected.outputSchemaJson}
                />
                <SchemaBlock
                  label="OAuth scopes"
                  json={selected.requiredOAuthScopesJson}
                />
                <SchemaBlock label="Required APIs" json={selected.requiredApisJson} />
                <SchemaBlock
                  label="Documentation"
                  json={selected.documentationLinksJson}
                />
              </div>
            </>
          ) : null}
        </SheetContent>
      </Sheet>
    </div>
  )
}

function Detail({
  label,
  value,
}: Readonly<{ label: string; value: string }>) {
  return (
    <div>
      <p className="mb-1 text-xs uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <p>{value}</p>
    </div>
  )
}

function SchemaBlock({
  label,
  json,
}: Readonly<{ label: string; json: string }>) {
  let pretty = json
  try {
    pretty = JSON.stringify(JSON.parse(json), null, 2)
  } catch {
    // keep raw
  }
  return (
    <div>
      <p className="mb-1 text-xs uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <pre className="overflow-x-auto rounded-md border border-border bg-muted/40 p-3 text-xs text-muted-foreground">
        {pretty || "—"}
      </pre>
    </div>
  )
}
