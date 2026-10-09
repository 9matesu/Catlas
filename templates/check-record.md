# Check record: <diagram file>

One record per diagram per round. The reviewer signs the record, not the diagram. A diagram without a passing record is a draft.

Diagram: `diagrams/<name>.mmd`
Source hash: `<output of git hash-object diagrams/<name>.mmd, recomputed every round>`
Budget: nodes <n>/12, edges <m>/14

## Gate A: text lint

Command: `python scripts/mermaid-lint.py diagrams/<name>.mmd`
Result: `<paste output>`

## Gate B: render freshness

Render command: `<the exact command used>`
Output: `<path to svg or png>`
Rerendered after the last `.mmd` edit: yes or no
Stale images are the most common failure. If the hash above differs from the hash at render time, rerender.

## Gate C: vision

Read the render at full width. Check each box and each edge:

* Text outside boxes: none, or `<box label>` with the fix applied.
* Stacked edge labels: none, or `<edge pair>` with the fix applied.
* Clipped names: none, or `<name>` with the fix applied.

Fix order: shorten labels first, split the diagram second. At most 3 rounds, then split or ask.

## Gate D: trace

Sample <n> edges. For each: label, source `path:line` with grep hit, sink `path:line` with grep hit, data type matches `flux.json`.

| edge | source | sink hit | type hit |
| ---- | ------ | -------- | -------- |
| `<label>` | `<path:line>` | yes or no | yes or no |

A no anywhere fails the gate. Fix the diagram or the flux record, then restart at gate A.

## Verdict

pass or fail. Rounds used <n>/3. Signed: `<agent>` on `<date>`.
