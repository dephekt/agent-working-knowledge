# Agent Planning

A central home for durable design briefs — the artifacts that turn long
exploration / brainstorm sessions into concrete plans that get implemented.

Each effort lives under `docs/briefs/` as one markdown file per topic ("slug").
The brief is the centerpiece: context, pinned decisions, the shape of the work,
open forks, and a phased plan. Mirrors the `~/upsun/dephekt/agent-planning`
docs system.

## Current briefs

<div class="grid cards" markdown>

-   :material-leaf: **[Grow control system](briefs/grow-control-system.md)**

    ---

    MQTT-based, multi-site grow control system (moving off Home Assistant):
    autonomous per-site control islands with local history and app-owned auth;
    central infrastructure provides only replaceable remote access and identity.

    Status: **Phase 1 deployed locally + site OTA shipped** · Lead: Daniel

-   :material-leaf: **[Grow app Phase 1](briefs/grow-app-phase-1.md)**

    ---

    Site-mode SvelteKit/Svelte 5 HMI for Daniel's local broker: MQTT
    discovery-derived entities, retained/live state, SSE updates, local command
    mediation, and per-device stable/edge firmware updates.

    Status: **deployed locally + OTA shipped** · Lead: Daniel

-   :material-palette: **[Grow app UI redesign workflow](briefs/grow-app-ui-redesign.md)**

    ---

    Mission Control direction for the next grow-app HMI iteration: dark
    instrument-panel dashboard, curated settings panels, local Influx-backed
    history trends, and substrate/Pulse-class sensing roadmap placeholders.

    Status: **Mission Control direction selected** · Lead: Daniel

</div>

## Conventions

Brief slugs are `<topic>` kebab-case (e.g. `grow-control-system`), or
`<date>-<topic>` for time-boxed notes. Decisions use inline badges
(<span class="badge badge-decided">decided</span>,
<span class="badge badge-open">open</span>,
<span class="badge badge-deferred">deferred</span>). Diagrams are embedded as
Mermaid source so they render here and on GitHub and regenerate via the
`diagram` skill. Serve locally with `mkdocs serve`.
