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
  onAssistantTextUpdated?: (text: string) => void
  onReconnected?: () => void
  onTurnStarted?: () => void
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

  useEffect(() => {
    handlersRef.current = handlers
  }, [handlers])

  useEffect(() => {
    if (!sessionId) return

    let cancelled = false
    let connection: HubConnection | null = null
    let receiving = false
    let streamId = ""
    let sequence = 0
    let retryTimer: ReturnType<typeof setTimeout> | null = null

    const scheduleRetry = () => {
      if (cancelled || retryTimer) return
      setConnectionState("disconnected")
      retryTimer = setTimeout(() => { retryTimer = null; void connect() }, 3000)
    }

    const connect = async () => {
      if (!connection || cancelled || connection.state !== HubConnectionState.Disconnected) return
      setConnectionState("connecting")
      try {
        await connection.start()
        if (cancelled) { await connection.stop(); return }
        await connection.invoke("JoinSession", sessionId)
        setConnectionState("connected")
        handlersRef.current.onReconnected?.()
      } catch { scheduleRetry() }
    }

    const start = async () => {
      connection = new HubConnectionBuilder()
        .withUrl(apiUrl("/api/v1/hubs/admin-authoring"), {
          accessTokenFactory: async () =>
            (await ensureFreshAccessToken()) ?? "",
        })
        .withAutomaticReconnect()
        .configureLogging(LogLevel.Warning)
        .build()

      connection.on("TurnStarted", () => {
        receiving = true
        streamId = ""
        sequence = 0
        handlersRef.current.onTurnStarted?.()
      })
      connection.on("AssistantTextUpdated", (payload: { sessionId: string; streamId: string; sequence: number; text: string }) => {
        if (cancelled || !receiving || payload.sessionId !== sessionId) return
        if (payload.streamId === streamId && payload.sequence <= sequence) return
        streamId = payload.streamId
        sequence = payload.sequence
        handlersRef.current.onAssistantTextUpdated?.(payload.text)
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
        receiving = false
        handlersRef.current.onTurnCompleted?.(result)
      })
      connection.on("TurnFailed", (payload: { message?: string }) => {
        receiving = false
        handlersRef.current.onTurnFailed?.(
          payload?.message ?? "Authoring turn failed",
        )
      })

      connection.onreconnecting(() => {
        if (!cancelled) setConnectionState("reconnecting")
      })
      connection.onreconnected(async () => {
        if (cancelled || !connection) return
        try {
          await connection.invoke("JoinSession", sessionId)
          setConnectionState("connected")
          handlersRef.current.onReconnected?.()
        } catch { await connection.stop() }
      })
      connection.onclose(() => {
        scheduleRetry()
      })
      await connect()
    }

    void start()

    return () => {
      cancelled = true
      if (retryTimer) clearTimeout(retryTimer)
      if (connection && connection.state !== HubConnectionState.Disconnected) {
        void connection.invoke("LeaveSession", sessionId).catch(() => undefined)
        void connection.stop()
      }
    }
  }, [sessionId])

  return { connectionState }
}
