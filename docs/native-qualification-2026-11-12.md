# Native Altium qualification — 2026-11-12

**Follow-up:** the connectivity failures below were fixed and rerun successfully;
see the [physical annotation and hierarchy rerun](native-connectivity-fix-2026-11-12.md).
This page preserves the original observations. Its CAM findings remain open.

Actual Altium Designer Professional **26.11.1** was used for these tests through
`coffeenmusic/altium-mcp` revision
`9ad05d3009912d54ed183221abd244bb86f18696`. The independent readers were Universal
Netlist **1.14.4** and Gerbonara **1.6.3**. Results are scoped to the cases below.

| Case | Native observation | Independent result | Decision |
| --- | --- | --- | --- |
| Single-sheet control, derived from the installed Bluetooth Sentinel microcontroller sheet | 15 components, 65 compiled pin memberships | Same 15 components and all 65 `(reference, pin, net)` tuples match exactly | Pass for this control |
| Complete installed Bluetooth Sentinel example, including hierarchy and physical annotation | 72 components, 224 compiled pin memberships | 70 components, 220 memberships; only 34 exact tuples match | Fail equivalence; do not use the saved parser as physical connectivity authority |
| Native Fabrication OutputJob, Gerber and NC Drill only | 20 Gerber files, 1 drill file, 8 ancillary files | All 21 manufacturing files parse; all 29 files remain hashed in the manifest | Parsing exercised; package review remains open |
| Native board/drill cross-check | 173 vias with nominal 0.3 mm holes | 173 drill objects; 0.299974 mm after native imperial export rounding | Count/diameter cross-check passes |

The hierarchical comparison has 71 native-only pin identities, 67 parser-only
identities, and 119 differing net names on shared identities. These categories
must not be interpreted as that many independent circuit faults: physical
annotation already changes which component a reference identifies. The parser
does not apply the project's `.Annotation` mapping. The remaining component/pin
count differences have not been fully diagnosed. No renaming or filtering was
used to force agreement.

## CAM findings and limits

The generated package is intentionally an example qualification input, not a
release package. Only the disposable copy's Fabrication OutJob was adjusted:
disconnect ODB output, direct the generated-files container to a new local
`Qualification CAM` folder, and disable automatic output opening/project addition.
Gerber and drill configuration, including relative origin and imperial units,
was retained. No printer, cloud release or manufacturing order was invoked.

The native Gerber report identifies `.GKO` as **Keep-Out Layer**. Its plotted
bounds are about 0.05 mm outside the native 80 × 55 mm outline because of the
stroke width. This agreement does not establish a fabrication profile. The
adapter previously inferred `outline` from `.GKO`; that inference is removed.
The reviewed layer map labels it `keepout`, and labels `.G1`/`.G2` using the native
Gerber report. The required fabrication outline remains unidentified.

The final CAM report retains 39 findings: 20 deprecated G70 parser warnings,
8 unrecognized ancillary files, 9 unclassified layers, 1 empty mechanical layer,
and 1 missing required outline role. These are review findings, not 39 confirmed
board defects. Individual SVG previews were generated. Registration, contour
closure, copper-to-IPC connectivity, native DRC and supplier DFM were not qualified.

## Reliable native capture

An initial harness syntax error was corrected before it performed project
operations. More importantly, `DM_Compile` returned an empty flattened model for
newly loaded control projects. Opening an exact schematic and using
`DM_CompileEx(True, Cancelled)` produced the expected model. Both comparisons above
were rerun with that forced compile. Empty models and cancelled/failed compiles
are not acceptance results.

The tested [capture template](../altium-design-review/scripts/native_membership_capture.pas)
is a **body for `run_altium_script`**, not a standalone Pascal program. It:

1. Requires an existing disposable project, a prepared output directory, unused
   output filenames, and a target that is not already open.
2. Records the open-project/document-state baseline, opens the exact target and
   one of its schematics, and forces a compile on that project object.
3. Exports all flattened component pins to `native-connectivity.tsv`, preserving
   physical designator, pin number, flattened net name and local net name.
4. Closes the disposable project without saving and records the workspace state
   again. An empty pin export produces an `ERROR:` result.

Render `__PROJECT_PATH__` and `__OUTPUT_DIRECTORY__` with absolute paths to the
copy and a fresh evidence folder. Escape every single quote in either path as
two single quotes before substitution; the output directory placeholder excludes
the trailing separator already in the template. Run the rendered body with the
Altium MCP sandbox. Check **both** its outer success flag and `result`: an
`ERROR:` result is a refusal/failure even when the script transport succeeded.
The template's successful 65-pin capture and its existing-output refusal were
both exercised in Altium.

Keep the source snapshots, rendered script, raw tool response, TSVs, comparison
JSON, source hashes and output manifest together outside the repository. Hash
all copied source dependencies before and after the run. Normalize the complete
TSV to the companion's comparison format, binding the exact project hash and
variant; never infer freshness from a project hash alone. Preserve empty or
unconnected-net evidence for explicit investigation rather than inventing names.
The current tested cases use `<Default>` and do not qualify assembly variants.

The native launcher may raise Altium. Arrange permission for any focus changes
and give the desktop back after a bounded batch. Snapshot equality describes
open/modified flags and focused project; it is not a byte-level proof about
unsaved editor buffers.

## Preservation and follow-up

All testing used private disposable copies of installed Altium examples. Original
example files were not edited. Copied schematic, board, annotation and project
bytes remained unchanged; only the explicitly prepared copied OutJob changed.
Workspace project/document states matched before and after the captures, and the
pre-existing project remained open. The vendor example sources and private
workspace paths are not redistributed here; the
[machine-readable record](native-qualification-2026-11-12.json) retains aggregate
results and artifact hashes.

The generic adapters in `hw-skills` now hash and flag ignored physical annotation,
return a nonzero review status for it, and require evidence for a `.GKO` outline
assignment. Three regression cases bring that integration suite to 25 tests.
Installed skills are junctions to these repositories, so the fixes and guidance
apply without replacing any customized installation.

Next priorities are physical-annotation/hierarchy correctness, native variants
and ERC/DRC, and explicit fabrication-profile/layer qualification. Interactive
assembly/iBOM is deferred.
