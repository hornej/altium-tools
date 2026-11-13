# Backend integration boundary

This repository owns Altium-specific skills, adapters, installation guidance and
acceptance evidence. It consumes generic engineering and sourcing evidence from
[hw-skills](https://github.com/hornej/hw-skills); the generic repository does not
need Altium to run.

Third-party backends remain separately versioned dependencies. Current candidates
are [coffeenmusic/altium-mcp](https://github.com/coffeenmusic/altium-mcp),
[eda-agent](https://github.com/salitronic/eda-agent),
[Altium Monkey](https://github.com/wavenumber-eng/altium_monkey),
[altium-workspace-mcp](https://github.com/Heegiiny/altium-workspace-mcp),
[altium-designer-mcp](https://github.com/embedded-society/altium-designer-mcp),
and the [Altium iBOM exporter](https://github.com/zharovdv/InteractiveHTMLBOM4Altium2).
Listing a candidate does not install it or qualify its native behavior.

The [dated landscape evaluation](https://github.com/hornej/hw-skills/blob/main/docs/tool-landscape-2026-11-12.md)
contains the comparative evidence and proposed pilots. Pin a tested backend
revision and retain its license/notice rather than copying whole upstream trees.
Keep required document identity, variant, coordinate units, compile freshness,
source hashes, coverage and actual save/edit effects in adapter outputs.

The [native qualification record](native-qualification-2026-11-12.md) now documents
actual AD26.11.1 compile, membership and OutputJob tests. The subsequent
[annotation/hierarchy fix and rerun](native-connectivity-fix-2026-11-12.md) matches
all 224 hierarchical and 65 single-sheet memberships. Annotated assembly variants
remain blocked pending qualification. Actual Gerber/drill parsing and native hole
measurements were tested, with CAM review findings retained. Interactive assembly
is deferred.

## Existing command contracts

Two shared file-analysis adapters are now integrated through the optional
`hardware-design-review` skill: Universal Netlist 1.14.4 for saved pin/net membership
and Gerbonara 1.6.3 for manufacturing-file inspection. See the
[Altium handoff and qualification scope](../altium-design-review/references/connectivity-integration.md).
Their implementations and dependencies live in `hw-skills`; existing Altium
scripts do not import them or require that checkout.

`altium-design-review/scripts/audit_exports.py` retains its CLI and schema version
1. It consumes a `.PrjPCB`, explicit variant and BOM/PnP CSVs; its output records
sources, raw fields, findings, reconciliation and coverage. The current
implementation keeps CSV checks and Altium variant parsing together to preserve
behavior during relocation. A future generic executable extraction should use a
versioned evidence interface and retain these regression cases.

The portable component/interface review guidance now lives in the
[`hardware-design-review` skill](https://github.com/hornej/hw-skills/tree/main/hardware-design-review).
Altium references forward to that shared material. The Altium release checklist
and native generation instructions remain here.

Never interpret a status-only MCP response, parser success or zero exit status
as native design validation. Select one live backend for an operation and retain
independent saved/exported evidence when checking its result.
