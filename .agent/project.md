# Agent Project Metadata

This repo is the durable planning and task-manifest home for agent-driven work.
Kanboard owns task state; Codeberg/Forgejo owns source, branches, PRs, review,
CI, releases, and package artifacts.

## Shared Kanboard

- Public URL: `https://kanban.ai.dephekt.net`
- LAN URL: `http://containers.home.arpa:8097`
- Public task link format: `https://kanban.ai.dephekt.net/i/<TASK_REF>`
- Local task references use stable prefixes such as `HGC`, `MED`, `AGT`, and
  `HER`.

## Initial Project

- Kanboard project: `Hydro Grow Control`
- Prefix: `HGC`
- Primary repos:
  - `stackdrift-images/agent-working-knowledge`
  - `stackdrift-images/grow-app`
  - `stackdrift/grow-fleet`
  - `stackdrift/media-stack`
  - `stackdrift/esphome-components`

`esphome-components` may keep Codeberg-native issues for public reusable
component support; Hydro product work should still use `HGC-*` references.
