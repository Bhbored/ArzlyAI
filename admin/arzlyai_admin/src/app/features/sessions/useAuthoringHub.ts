import { useEffect, useRef, useState } from "react"
import {
  HubConnection,
  HubConnectionBuilder,
  HubConnectionState,
  LogLevel,
} from "@microsoft/signalr"
import { apiUrl, ensureFreshAccessToken } from "../../shared/api/http"
import type {
  AuthoringTurnResponse,
  ValidationResult,
} from "../../shared/types"

export type ConnectionState =
  | "connecting"
  | "connected"
  | "disconnected"
  | "reconnecting"

interface AuthoringHubHandlers {
  onTurnStarted?: () => void
  onContentDelta?: (content: string) => void
  onToolStarted?: (name: string) => void
  onToolCompleted?: (name: string) => void
  onDraftUpdated?: () => void
  onValidationChanged?: (result: ValidationResult) => void
  onTurnCompleted?: (result: AuthoringTurnResponse) => void
  onTurnFailed?: (message: string) => void
}

export function useAuthoringHub(
  sessionId: string | undefined,
  handlers: AuthoringHubHandlers,
) {
  const [connectionState, setConnectionState] =
    useState<ConnectionState>("disconnected")
  const handlersRef = useRef(handlers)
  handlersRef.current = handlers

  useEffect(() => {
    if (!sessionId) return

    let cancelled = false
    let connection: HubConnection | null = null

    const start = async () => {
      setConnectionState("connecting")
      connection = new HubConnectionBuilder()
        .withUrl(apiUrl("/api/v1/hubs/admin-authoring"), {
          accessTokenFactory: async () =>
            (await ensureFreshAccessToken()) ?? "",
        })
        .withAutomaticReconnect()
        .configureLogging(LogLevel.Warning)
        .build()

      connection.on("TurnStarted", () => handlersRef.current.onTurnStarted?.())
      connection.on("ContentDelta", (payload: { content?: string }) => {
        if (payload?.content != null) {
          handlersRef.current.onContentDelta?.(payload.content)
        }
      })
      connection.on("ToolStarted", (payload: { name?: string }) => {
        if (payload?.name) handlersRef.current.onToolStarted?.(payload.name)
      })
      connection.on("ToolCompleted", (payload: { name?: string }) => {
        if (payload?.name) handlersRef.current.onToolCompleted?.(payload.name)
      })
      connection.on("DraftUpdated", () => handlersRef.current.onDraftUpdated?.())
      connection.on("ValidationChanged", (result: ValidationResult) => {
        handlersRef.current.onValidationChanged?.(result)
      })
      connection.on("TurnCompleted", (result: AuthoringTurnResponse) => {
        handlersRef.current.onTurnCompleted?.(result)
      })
      connection.on("TurnFailed", (payload: { message?: string }) => {
        handlersRef.current.onTurnFailed?.(
          payload?.message ?? "Authoring turn failed",
        )
      })

      connection.onreconnecting(() => {
        if (!cancelled) setConnectionState("reconnecting")
      })
      connection.onreconnected(async () => {
        if (cancelled || !connection) return
        setConnectionState("connected")
        await connection.invoke("JoinSession", sessionId)
      })
      connection.onclose(() => {
        if (!cancelled) setConnectionState("disconnected")
      })

      try {
        await connection.start()
        if (cancelled) {
          await connection.stop()
          return
        }
        await connection.invoke("JoinSession", sessionId)
        setConnectionState("connected")
      } catch {
        if (!cancelled) setConnectionState("disconnected")
      }
    }

    void start()

    return () => {
      cancelled = true
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        void connection.invoke("LeaveSession", sessionId).catch(() => undefined)
        void connection.stop()
      }
    }
  }, [sessionId])

  return { connectionState }
}
