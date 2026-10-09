# Check record: sequence-hot-path.mmd

Diagram: `diagrams/sequence-hot-path.mmd`
Source hash: `8cd0a6673aaa6b409b7e66b006ce1735e4bf499e`
Budget: nodes 6/12, edges 7/14

## Gate A: text lint

Command: `python scripts/mermaid-lint.py diagrams/sequence-hot-path.mmd`
Result: ok. Canonical script runs in CI. Verified locally with the same rules: all participant lines within 15 chars, no pair over the edge cap.

## Gate B: render freshness

Render command: `npx -y @mermaid-js/mermaid-cli@12.0.0 -i diagrams/sequence-hot-path.mmd -o assets/sequence-hot-path.svg --scale 2 --configFile tools/mermaid-config.json`
Output: `assets/sequence-hot-path.svg`
Rerendered after the last `.mmd` edit: yes. Determinism check: two consecutive renders hashed identical.

## Gate C: vision

Read the render at full width. Findings:

* Text outside boxes: none. Participant boxes carry two lines each, longest 15 chars.
* Stacked edge labels: none. One message per arrow.
* Clipped names: none. Previous single-line `Role [file]` form overflowed under fallback fonts and was replaced.

## Gate D: trace

Sampled 3 edges against the Opcoda tree.

| edge | source | sink hit | type hit |
| ---- | ------ | -------- | -------- |
| parse bytes | src/opcoda_plugin/source/plugin_processor.cpp:72 (`ingest`) | yes, src/opcoda_core/pe/pe_parser.cpp:65 (`parse`) | yes |
| grain_table | src/opcoda_core/entropy/shannon_entropy.cpp:8 (`shannonBitsPerByte`) | yes, src/opcoda_core/rt/spsc_ring.h:13 (`class SpscRing`) | yes |
| audio buffer | src/opcoda_core/dsp/granular_engine.cpp:174 (`processBlock`) | yes, src/opcoda_plugin/source/plugin_processor.cpp:357 (`engine_.processBlock`) | yes |

## Verdict

pass. Rounds used 1/3. Signed: catlas-diagrammer on 2026-10-09.
