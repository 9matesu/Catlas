# Changelog

## 1.1.0 - 2026-10-09

Cross OS and confirm loop. Both render scripts now call pinned mermaid-cli 12.0.0 with a shared deterministic config, so Linux, macOS, and Windows produce byte identical SVGs. Added `tools/render-mermaid.sh`, rewrote the `.ps1` around npx with the Edge path as fallback only. Added the four gate confirm loop with per diagram check records, a record template, and a worked record for the sequence diagram. Reviewer verifies record hashes instead of eyeballing diagrams.

## 1.0.2 - 2026-10-09

Fixed sequence participant boxes: single-line `Role [file]` names ran 20 plus chars and poked out of the box under fallback fonts on GitHub. Participants are now two lines, role plus stripped file, 15 chars max per line. Lint checks participant lines. Style guide updated.

## 1.0.1 - 2026-10-09

Fixed label overflow in the Opcoda example diagrams: text sticking out of boxes, stacked edge labels between the same node pair, clipped file names. Labels are now name only at 15 chars max, node refs strip the extension, full paths live in the companion table. The context diagram lost its wrong-way return edge. `mermaid-lint.py` now fails on long labels and on more than 2 edges per node pair. Style guide, review checklist, and diagrammer agent updated to match.

## 1.0.0 - 2026-10-09

First production cut. Skill phases, UML gray style guide, tracing playbook, review checklist, voice guide, 5 templates, lint script, Edge render script, 3 subagents, full worked example over a PE file to grain pipeline.
