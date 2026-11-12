# altium-tools

Reusable Altium skills and focused helpers for local libraries, Altium 365
maintenance, design review, native readback and manufacturing outputs.

This repository was split from [hw-skills](https://github.com/hornej/hw-skills)
with the Altium file history preserved. See [migration provenance](docs/history.md)
for the source revision and commit mapping.

## Skills

| Skill | Use it for |
| --- | --- |
| [altium-library-migrate](altium-library-migrate/SKILL.md) | Discover, normalize, audit and consolidate SchLib/PcbLib libraries; prepare Library Importer inputs. |
| [altium-365-library-maintain](altium-365-library-maintain/SKILL.md) | Maintain Workspace metadata, models and templates; prepare synchronization inputs; inspect native panels and diagnose saves. |
| [altium-design-review](altium-design-review/SKILL.md) | Review Altium BOMs, assembly variants, native sources, PCB rules, xSignals and release outputs. |

Skill names and helper command lines are unchanged. Generic component selection,
sourcing, origin evidence and hardware-review guidance live in
[hw-skills](https://github.com/hornej/hw-skills). Its skills are optional companions;
the offline Altium helpers do not import code from another checkout.

## Install in Codex

```text
Use $skill-installer to install altium-library-migrate,
altium-365-library-maintain, and altium-design-review
from https://github.com/hornej/altium-tools.
```

Install all three side by side to retain their companion reference links. For
an existing installation, compare and preserve local edits before replacing a
same-name directory. Local developer installations can use junctions/symlinks
to these folders; retarget existing links to this checkout after migration.
Keep installed names unchanged. Changes become available on the next Codex turn.

For the generic companions, install `hardware-design-review`,
`digikey-part-selection`, `part-sourcing` and `st-origin-lookup` from `hornej/hw-skills`.
Cross-repository references use canonical URLs and can also be read from the
corresponding installed skill. Neither checkout requires a particular sibling
directory layout.

## What runs automatically

| Helper | Result |
| --- | --- |
| `audit_exports.py` | Reads BOM/PnP CSV and saved Altium variant metadata; writes a new JSON report. |
| `native_inventory.py` | Inventories saved schematic/PCB files using Altium Monkey. Full circuit and physical-instance reconciliation remain review work. |
| `migrate.py` / `normalize_config.py` | Generate local library staging and adapt an exported importer configuration. |
| `sync_artifacts.py` | Prepares synchronization CSV/schema files or summarizes a private log; does not execute Workspace updates. |
| `altium_panel_probe.py` | Discovers native panels and optionally performs scoped read-only UIA queries through Adom Bridge. |
| `altium_explorer_states.py` / `Read-AltiumExplorerStates.ps1` | Summarize or acquire scoped Explorer state evidence; see the native-readback reference for requirements and limits. |

This repository is also the integration home for separately installed Altium
backends. It does not bundle an MCP server, a general Workspace write API, or
third-party engines. The [backend integration boundary](docs/integrations.md)
records how those tools should be qualified and connected.

## Try an offline review

Python 3.10+ is enough for the [synthetic BOM walkthrough](altium-design-review/examples/bom-review/README.md):

```sh
python altium-design-review/scripts/audit_exports.py --project altium-design-review/examples/bom-review/Demo.PrjPCB --variant "Demo assembly" --bom altium-design-review/examples/bom-review/bom.csv --pnp altium-design-review/examples/bom-review/pnp.csv --out demo-review.json
```

The example contains intentional mistakes. The helper preserves inputs and
refuses an existing output path; a produced report is not engineering signoff.

## Dependencies

| Workflow | Requirements |
| --- | --- |
| CSV review and synchronization-file preparation | Python 3.10+, standard library only |
| Binary migration and saved native inventory | CPython 3.12 and `altium-monkey==2026.9.22`; see [requirements](altium-library-migrate/scripts/requirements.txt) and [workflow](altium-library-migrate/references/workflow.md) |
| Native import, editing and Workspace release | Altium Designer on Windows, appropriate Workspace access and features |
| Scoped panel queries | Python 3.10+, running Altium and Adom Bridge; see [native readback](altium-365-library-maintain/references/native-readback.md) |

Use an isolated engine environment. Some adapters use internal Monkey APIs;
qualify a different version before changing an existing runtime. Credentials,
private designs, Workspace exports and project-specific settings stay outside
this repository.

For release work, start with the [Altium PCB release checklist](altium-design-review/references/pcb-release-checklist.md)
and [OutputJobs guide](altium-design-review/references/outputjobs-manufacturing-files.md).
These retain Altium-specific operations; portable engineering criteria are linked
to the generic hardware-review skill.

## Tests

From the repository root, with the pinned engine installed for migration:

```sh
python -B -m unittest discover -s altium-library-migrate/tests -v
python -B -m unittest discover -s altium-365-library-maintain/tests -v
python -B -m unittest discover -s altium-design-review/tests -v
```

The synthetic tests do not need a private project, live Workspace, desktop input
or credentials. CI runs all three suites on Windows/Python 3.12 and the two
standard-library suites on Linux/Python 3.10. Native compile/ERC/DRC, UI behavior
and Workspace acceptance remain distinct checks.

## License

Original skills and helpers are [MIT licensed](LICENSE).
[Altium Monkey](https://github.com/wavenumber-eng/altium_monkey) is separately
installed under its own AGPL-3.0-or-later terms. Other optional tools retain their
licenses. This is an independent project, not an official Altium product.
