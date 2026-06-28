# Grow App UI Redesign Workflow

Penpot-led design loop for the site-mode HMI

**Scope:** Use self-hosted Penpot as the visual design workspace for grow-app
layout changes while keeping the SvelteKit app and Playwright tests as the
production source of behavior.

**Status:** <span class="badge badge-info">Mission Control direction selected</span>

## Outcome

This brief records the selected Mission Control direction for the next HMI code
pass, while preserving the reviewable design loop for future iterations:

1. Use the Claude Design mockup in `grow-app/design/mission-control` as the
   high-fidelity target for the next overview/settings iteration.
2. Keep Penpot as the discussion workspace for design-token extraction,
   current-state screenshots, and future frame review.
3. Code the chosen direction in grow-app.
4. Verify with the existing check, unit, build, and Playwright suite.

Penpot is the discussion workspace. The SvelteKit app remains the source for
runtime behavior, MQTT mediation, command safety, and responsive rendering.

## Mission Control Direction

The next selected direction is the Claude Design mockup committed in
`/home/daniel/dev/grow-app/design/mission-control`. It is a high-fidelity
reference for look and behavior, not production code. Recreate the design in
SvelteKit/Svelte 5 using the existing app data flow; do not ship the prototype
HTML or its runtime.

Visual target:

- Dark instrument-panel shell: background `#0a0b0d`, panel `#101216`, hairline
  borders, amber active states, cyan secondary accents, green/amber/red status.
- IBM Plex Sans for UI text and IBM Plex Mono for numeric readings, IDs, status,
  and timestamps. The deployed app's all-monospace fallback is a font-loading bug,
  not the intended aesthetic.
- Full-width command bar with site identity, broker state, device/entity counts,
  clock, and Dashboard/Settings navigation. Settings shows an amber update dot
  when any controller has a firmware update available.
- Dashboard as a 12-column operations surface, not per-device cards: Trends,
  Circuits, Thermal, Water, Climate, and planned Substrate.
- Settings as a controller selector plus category tabs: Controls, Updates,
  Alerts, Calibration, Maintenance, Diagnostics, Other.

Implementation principle:

> Curate recognized entity shapes; otherwise fall back to the generic entity
> list.

The first app pass should use the retained MQTT snapshot and existing
`grow-ui.v1` metadata already published by `grow-fleet`. Add curated renderers
in grow-app keyed by recognized groups/entity shapes, with the current
collapsible list as the default. Do not require a firmware schema change for the
first Mission Control pass.

Known recognized shapes:

| Shape | Current source | Mission Control treatment |
|---|---|---|
| Firmware metadata + update entity | `grow-firmware-device.v1`, app channel state, update/check entities | Restyled Updates panel with Stable/Edge, Installed, Latest, State, SHA, Check, Apply. |
| AtomS3U threshold alerts | `thresholds` group with high/low numbers and high/low binary sensors | Alert rule cards grouped by metric with live marker, safe band, armed/alert state. |
| Atlas calibration groups | `ph_cal`, `ec_cal`, `rtd_cal`, `orp_cal` groups | Guided calibration flow with ordered steps, probe health, live reading, stabilization gate. |
| Camera + thermal controls | `thermal_view` dashboard camera group and quick controls | Thermal tile plus attached controls, not a generic settings camera row. |

Substrate and Pulse/VWC-class readings are roadmap placeholders until a real
device or bridge publishes those entities. If no substrate device exists, the
dashboard may reserve the layout with a planned/empty state, but it must not
pretend mock readings are live.

## Mission Control Work Tracks

1. **Design system and layout in grow-app.** Replace the light, card-heavy HMI
   with the Mission Control shell, command bar, responsive 12-column dashboard,
   controller selector, tabs, and compact metric tables. Keep MQTT server-side
   and browser reads over snapshot/SSE.
2. **Curated presentation registry.** Extend `device-presentation.ts` so the
   app can detect recognized settings shapes and route them to curated Svelte
   components while preserving generic sections for unknown devices.
3. **Curated settings surfaces.** Restyle the existing firmware update panel,
   add threshold alert rule cards, and build the guided Atlas calibration flow.
   Calibration must show the live sensor value for the active probe and disable
   the calibrate action until the recent reading buffer is stable.
4. **History and trends.** Back charts with site-local InfluxDB populated by a
   local MQTT history recorder. The dashboard Trends panel should be backed by
   a server-mediated grow-app history API; browsers must not connect directly
   to MQTT or InfluxDB.
5. **Substrate/Pulse roadmap.** Plan VWC, pore-water EC, bulk EC, and substrate
   temperature around a real MQTT entity contract. The first doc/Kanban issue
   should specify the device or bridge shape before app UI work begins.

## Repository Responsibilities

| Repo | Responsibility |
|---|---|
| `grow-app` | Mission Control visual system, curated presentation registry, app-owned auth UI later, history API client/server route, charts, and fixture-backed UI tests. |
| `grow-fleet` | Device metadata and future substrate/Pulse-class entity discovery. No first-pass schema change unless current `grow-ui.v1` cannot identify a curated shape. |
| `media-stack` | Per-site InfluxDB and history-recorder deployment following existing stack conventions: Makefile targets, remote Docker context, secrets flow, and `grow-mqtt` network attachment when required. |
| `agent-planning` | Durable brief and eventual Kanban issue breakdown before implementation starts. |

## History And Identity Defaults

These decisions come from the revised architecture:

- **History backend:** InfluxDB, deployed per site beside broker and grow-app.
- **Ingestion path:** separate `grow-history-recorder` sidecar subscribes to
  local MQTT and records numeric sensors plus binary sensor states first.
- **History access:** grow-app serves chart APIs; browsers never connect
  directly to InfluxDB.
- **Remote access:** `<site-slug>.grow.dephekt.net` routes to that same site
  app. Pangolin/Newt is routing only; grow-app owns OIDC and local fallback
  login.

## Open Questions

These are intentionally not decided by the mockup:

- **Retention policy:** raw sensor resolution, downsampling windows, and which
  entities are worth storing.
- **Measurement identity:** stable labels/tags for site, environment, node,
  entity, component, unit, and device class.
- **Substrate device path:** native ESPHome sensor package, Pulse bridge, or
  another VWC probe.
- **Chart library:** choose during implementation after evaluating bundle size,
  Tab5 performance, and multi-series styling in the dark theme.
- **Auth UI integration:** exact login screen, local fallback password setup,
  and admin disable flows need design before the app-owned auth phase.

## Kanban Draft

Do not create Kanban issues until this brief is accepted. The likely split is:

1. Mission Control design system and dashboard shell.
2. Curated settings renderer registry and fallback contract.
3. Firmware Updates panel restyle.
4. Threshold alert rule cards for AtomS3U.
5. Guided Atlas calibration with live stability gating.
6. Per-site InfluxDB and history-recorder deployment plan.
7. History ingestion and grow-app history API.
8. Trends chart implementation.
9. Substrate/Pulse device-contract planning.
10. App-owned auth UI: OIDC login, local admin, and local fallback password setup.

## Infrastructure

Penpot is owned by `media-stack` as a first-class stack:

| Surface | Value |
|---|---|
| Public URL | `https://design.ai.dephekt.net` |
| Internal URL | `http://containers.home.arpa:9001` |
| Compose project | `penpot` |
| Keycloak client ID | `penpot` |
| OIDC callback | `https://design.ai.dephekt.net/api/auth/oidc/callback` |
| Pangolin SSO | disabled |
| App-native auth | Keycloak OIDC |

Persistent state is held in Docker volumes:

- `penpot_penpot-postgres-v15` for PostgreSQL.
- `penpot_penpot-assets` for uploaded assets and design media.

Deployment checklist:

```bash
make inject-secrets
make sync-secrets-media
make penpot-up
```

Operator steps still required outside git:

1. Create the Keycloak confidential client `penpot` in the `home` realm.
2. Set the valid redirect URI to
   `https://design.ai.dephekt.net/api/auth/oidc/callback`.
3. Store the generated client secret at
   `op://Develop/Penpot/OIDC client secret`.
4. Store `PENPOT_SECRET_KEY` and `PENPOT_DATABASE_PASSWORD` in the 1Password
   paths documented in `media-stack/penpot/README.md`.
5. Deploy and confirm public and internal access.

Primary Penpot references:

- Docker self-hosting:
  `https://help.penpot.app/technical-guide/getting-started/docker/`
- Configuration and OIDC:
  `https://help.penpot.app/technical-guide/configuration/`
- MCP server:
  `https://help.penpot.app/mcp/`

## Penpot Workspace

Create one Penpot file named `Hydro Grow Control HMI`.

Pages or boards:

| Page | Purpose |
|---|---|
| `Current State` | Imported screenshots from the real app render. |
| `Overview Concepts` | 2-3 operations-overview layout variants. |
| `Settings Concepts` | Calibration, maintenance, diagnostics, and update tooling. |
| `Device Detail Concepts` | Per-device drill-in and dense entity inspection. |
| `Chosen Direction` | The selected layout used for implementation. |
| `Design Tokens` | Colors, type, spacing, radii, and state treatments. |

Current-state screenshots come from grow-app:

```bash
pnpm design:screenshots
```

The test writes per-viewport PNG files into Playwright's `test-results`
output. Import those into the `Current State` page before creating concepts.

## MCP Protocol

Penpot MCP acts on the currently focused page in the active Penpot browser tab.
Use it carefully:

1. Enable MCP from the Penpot account integrations page and generate an MCP key.
2. Connect the active file from `File -> MCP Server -> Connect`.
3. Start with read-only prompts: list pages, inspect layers, summarize tokens.
4. Before any write, describe the intended change and target page.
5. First write test: create one disposable scratch frame.
6. Only then mutate the real HMI boards, in small reversible steps.

Do not run broad renaming, deletion, restyling, or page-wide refactors until the
focused page and selected board are verified.

## Information Architecture

The first redesign should split high-frequency operations from lower-frequency
tools:

| Route | Job |
|---|---|
| `/` | Operations overview: site status, device availability, key readings, active alerts, and safe high-frequency controls. |
| `/settings` | Calibration, maintenance, diagnostics, firmware/update affordances, and lower-frequency tools. |
| `/devices/:id` | Optional later device detail view for dense inspection and device-specific tools. |

Settings sections:

- `Calibration`
- `Maintenance`
- `Diagnostics`
- `Device updates` / firmware update state

Classification should start from existing data:

- UI metadata groups from retained `grow/<site>/<node>/_ui/config`.
- Entity `entityCategory`, especially `diagnostic`.
- Current dangerous-command classification.
- Writable versus read-only entity shape.

Avoid firmware/schema changes in the first design pass. Add a metadata extension
only if Penpot mockups prove the current `grow-ui.v1` grouping cannot express
the chosen layout.

## Review Gate

Before coding:

1. The `Current State` page contains desktop, Tab5, and phone screenshots.
2. `Overview Concepts` has 2-3 viable alternatives.
3. `Settings Concepts` covers calibration, maintenance, and diagnostics.
4. The selected direction is copied or summarized in `Chosen Direction`.
5. Penpot frame links are ready for the implementation PR.

## App Verification

Run the normal app suite after implementation:

```bash
pnpm check
pnpm test
pnpm build
pnpm test:e2e
pnpm design:screenshots
```

Acceptance criteria:

- No browser MQTT access; MQTT remains server-side.
- Desktop, Tab5 `1280x720`, and phone viewports render without horizontal
  overflow or incoherent overlap.
- Keyboard navigation reaches controls in a useful order.
- Touch targets remain usable on the Tab5 viewport.
- Dangerous controls keep visual separation and server-side confirmation.
- The overview/settings split does not hide active alerts or unsafe states.
