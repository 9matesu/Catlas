# Agents

This file tells coding agents how to work in this repo. OpenCode reads `SKILL.md` for the task. This file covers repo care.

## Build and check

No build step. This repo ships markdown, Mermaid, one Python lint script, one PowerShell render script.

```powershell
python scripts/mermaid-lint.py examples/opcoda-pe-pipeline/diagrams
powershell -File tools/render-mermaid.ps1 -Atlas examples/opcoda-pe-pipeline
```

Python means any Python 3 on PATH. The lint script uses stdlib only. The render script needs local Edge plus a vendored `mermaid.min.js` you provide.

## Conventions

Keep Mermaid GitHub native. One diagram per `.mmd` file. One direction per diagram. At most 12 nodes and 14 edges. Every `-->` carries a label with data and type. Gray `abstract` classDef for grouping nodes, white `concrete` for files with code. Keep the classDefs identical across diagrams.

Keep prose human. Load the humanizer rules in `references/voice-guide.md` before editing markdown. Sentence case headings. Straight quotes. No decorative bold. Code blocks, paths, commands, and error codes stay verbatim.

## Change process

Behavior change updates `SKILL.md`, the affected reference, the affected template, and `README.md` in the same commit. Example diagrams must still pass the lint script after any style change. Note Mermaid and Edge versions in `CHANGELOG.md` when renders shift.
