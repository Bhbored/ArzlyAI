import type { ReactNode } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export function DataTableShell({
  title,
  toolbar,
  children,
}: Readonly<{
  title?: string
  toolbar?: ReactNode
  children: ReactNode
}>) {
  return (
    <Card className="border-border/80 bg-card/80">
      {(title || toolbar) && (
        <CardHeader className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          {title ? <CardTitle className="text-base">{title}</CardTitle> : <span />}
          {toolbar}
        </CardHeader>
      )}
      <CardContent className="overflow-x-auto p-0">{children}</CardContent>
    </Card>
  )
}
