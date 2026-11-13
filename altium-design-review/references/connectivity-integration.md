# Saved connectivity and manufacturing inspection

The optional `hardware-design-review` companion from
[hw-skills](https://github.com/hornej/hw-skills/tree/main/hardware-design-review)
now supplies two independent saved/exported evidence adapters. They are shared
across CAD tools; this repository owns the Altium handoff and native acceptance.
Existing Monkey inventory and BOM/variant commands remain available unchanged.

## Altium connectivity handoff

Follow the companion's [connectivity instructions](https://github.com/hornej/hw-skills/blob/main/hardware-design-review/references/connectivity.md)
to install its pinned Universal Netlist 1.14.4 dependency beside that skill.
Run its `scripts/inspect_connectivity.mjs` with the exact `.PrjPcb`, named assembly
variant when present, and a new report path. Use installed skill paths or explicit
checkout paths; neither repository assumes a sibling checkout.

The report now supplies component pin/net membership and retains DNP parts,
parser-derived repeated-sheet identities and source-file hashes. Use Monkey
inventory for independent source UID and primitive evidence. Do not infer that
matching reference strings alone prove physical-instance identity.

Important engine boundary: when a project declares named variants, this pinned
engine requires one of them and refuses `<Default>`. A standalone SchDoc read
does not carry the project's variant or hierarchy. Do not quietly choose an
assembly variant merely to obtain a report.

For qualification on a real board, compare the entire `(physical reference,
pin, net)` membership with a fresh native compiled export for the same saved
source snapshot and variant. Preserve the native export and its generation
settings; normalize to the companion's optional comparison format without
discarding channels, multi-part pins, buses, power pins or unconnected pins.
Explain differences rather than renaming nets to force agreement. The adapter's
source hash checks do not establish native compile freshness or correctness.

Tests currently cover synthetic flat/repeated-sheet projects, a multi-part
component, named-variant selection and DNP retention through the real parser.
The [native AD26.11.1 fix and rerun](../../docs/native-connectivity-fix-2026-11-12.md)
matches all 65 pins on the single-sheet control and all 224 on the full annotated
Bluetooth Sentinel hierarchy. The companion applies annotation before extraction,
keeps port-connected hierarchical power local and retains isolated-pin names.
It reports each physical identity's source/matching basis and refuses unresolved
or ambiguous mappings. Annotated assembly variants remain blocked; general
equivalence, additional bus/harness/hidden-power features and alternate libraries
remain unqualified. Keep native ERC/DRC and saved parser results distinct.

Use the tested [native capture template](../scripts/native_membership_capture.pas)
on a disposable copy when repeating this comparison. It forces a full compile,
rejects empty results and pre-existing output files, and captures workspace states.
Follow its qualification instructions; an outer MCP success is not evidence of
successful compilation or correct membership.

## Manufacturing output handoff

Follow the companion's [Gerbonara instructions](https://github.com/hornej/hw-skills/blob/main/hardware-design-review/references/manufacturing-inspection.md)
for a separate Python 3.12 environment with Gerbonara 1.6.3. Point
`scripts/inspect_manufacturing.py` at the **actual unpacked OutputJob deliverables**,
and create the report outside that package.

Supply expected copper/mask/paste/outline/drill roles for the board's stackup
and service. Map Altium mechanical files from the selected OutJob configuration;
`GM1`, `GKO` and similar names need role evidence. Native testing confirmed that
`GKO` identifies the keepout layer, not automatically the fabrication profile.
Review parser warnings, missing/duplicate
layers, units, drill diameters/plating and possible drill offsets. The generated
SVGs are individual source-coordinate previews, not validated layer registration.

Retain the report alongside the source revision, OutJob settings, selected
variant, native rule results and supplier package manifest. IPC-356 records
provide another evidence source; this integration does not yet prove they match
the extracted copper. Native DRC, CAM visual review and supplier DFM remain
separate release-checklist items.
