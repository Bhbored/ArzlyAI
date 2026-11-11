# Integrations and workflow builder

Implemented in both React and the backend.

## Product behavior

- Navigation now says Integrations and routes to `/integrations`; the old URL redirects. This page shows integrations only. Built-in operations such as receipt analysis are processing components, not seeded workflows, and remain available inside the builder.
- Catalog lists workflows published by an admin, including archived versions. Legacy catalog rows without an admin publisher are excluded. No rows were deleted.
- Create workflow in Catalog opens the visual builder directly. It does not require an authoring-provider key. AI chat still requires a configured provider.
- Chat, Workflow builder, and Review are separate top-level workspace tabs. Unsaved builder edits survive tab changes. Chat takes the available width; long prose wraps while code and tables can scroll within their message.
- The builder has a searchable drag-and-drop component library, custom step cards, connection handles, and a selected-step settings panel. Clicking components is the keyboard/touch alternative to dragging. A new agent component creates its agent configuration; integration components select their registered definitions. Required mappings can be added from integration schemas. Input sources offer upstream outputs only, and cycle-forming connections are rejected.
- Details, Inputs, Agents, Settings, and Preview remain accessible from the builder. They cover workflow metadata, models and instructions, Harness settings, JSON schemas, background policy, admin notes, and safe preview. Save remains explicit.

## Contract additions

`POST /api/v1/admin/authoring/sessions` accepts optional `useVisualBuilder: true` to skip assistant availability checks during manual creation. The default chat behavior is unchanged.

Draft nodes accept optional `editorPosition: { x, y }`. Coordinates persist through draft save/reload but are not runtime configuration. No new relational migration is needed for this change. The earlier turn-recovery migration is still required if it has not been applied.

## Design and verification

The existing dark green app identity is retained. The canvas is the primary work surface; the component library and settings panel flank it on wide screens and stack on narrow screens. The grid helps with spatial placement, arrows communicate execution direction, and component icons distinguish agents, review, integrations, and processing. Energy 1, rhythm 2, motion 1: selection and drag feedback serve the task, with no decorative animation.

The accessibility and responsive-layout skills guided width containment, keyboard alternatives, and the mobile tab layout. Browser tests use deterministic API fixtures and a temporary local preview server which closes afterward; they do not call live providers or mutate a database.

Run `npm run test:e2e` in `admin/arzlyai_admin` to build and exercise these browser journeys. Windows uses installed Edge by default; `PLAYWRIGHT_CHANNEL` can choose a different installed browser. Other platforms use Playwright Chromium.

Verification covers Integrations filtering and legacy redirect, Catalog to builder creation, keyboard component insertion, integration drag-and-drop, required mappings, connected steps, saving/reloading canvas state, and long Markdown at 390px, 900px, and 1440px widths. Unit tests cover automatic agent creation and cycle rejection; backend tests cover admin-only catalog rows, manual creation without an assistant, and coordinate serialization.

Delivery review:

- Layout and behavior PASS: 5 browser journeys pass, including no message overflow and no overlapping builder tabs at all three tested widths. Node visibility after reload is asserted, not only presence in the DOM.
- Accessibility PASS for the changed controls: keyboard insertion is exercised, native form controls have labels, component controls have visible focus styles, and drag actions have click alternatives. Measured dark-theme contrast is 18.17:1 for body text, 4.79:1 for muted text and component boundaries, and 14.04:1 for selected/focus accents against the card surface.
- Visual purpose PASS: the existing app colors and typography are retained; component cards and connection arrows communicate workflow structure. The wide canvas and adjacent step inspector provide the focal point; narrow layouts stack the same controls.
- Checks PASS: 153 backend tests, 5 UI unit tests, 5 browser tests, React lint, and the production build. The builder is loaded as a separate bundle and there are no build warnings. The browser's temporary preview server is closed by the test teardown.
