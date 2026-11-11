# Authoring response streaming

The backend reads live provider responses for DeepSeek, Anthropic, Gemini, and OpenAI. React receives text updates through the existing authenticated `/api/v1/hubs/admin-authoring` SignalR connection. This is AI text streaming, not React server-side rendering.

The message POST still returns the complete saved `AuthoringTurnResponse`. Join the chat's SignalR group before submitting. The UI disables submission until the group connection is ready.

`AssistantTextUpdated` carries `{ sessionId, streamId, sequence, text }`. `text` is the accumulated visible text for that provider response, not a delta to append. Replace the temporary bubble with this value; ignore duplicate or older sequence numbers within a stream. Each model round has its own stream ID, so text before a tool call is replaced by the next response. Tool argument fragments and reasoning are not emitted to the UI.

`TurnCompleted` and the message POST response replace temporary text with the saved chat. `TurnFailed` or a failed POST clears temporary text and reloads the chat. A disconnected client can miss live updates; the POST response and a reconnect refetch recover persisted state. Partial replies are not persisted as completed messages. Interrupted provider streams fail the turn, and tool calls execute only after their arguments have been assembled.

DeepSeek and Anthropic use `stream: true`; Gemini uses `streamGenerateContent?alt=sse`; OpenAI uses the Agent Framework streaming API. HTTP provider reads use `ResponseHeadersRead` and the turn's cancellation token. Existing server turn timeouts still apply.

Protocol references: [DeepSeek](https://api-docs.deepseek.com/api/create-chat-completion/), [Anthropic](https://platform.claude.com/docs/en/build-with-claude/streaming), [Gemini](https://ai.google.dev/api/generate-content), [Agent Framework](https://github.com/microsoft/agent-framework).

Verification covers incremental provider text, truncated streams, fragmented tool arguments, and SSE framing. Live provider credentials are not used by the tests.
