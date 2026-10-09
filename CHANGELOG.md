# Changelog

## 1.0.1 - 2026-10-09

Fixed label overflow in the Opcoda example diagrams: text sticking out of boxes, stacked edge labels between the same node pair, clipped file names. Labels are now name only at 15 chars max, node refs strip the extension, full paths live in the companion table. The context diagram lost its wrong-way return edge. `mermaid-lint.py` now fails on long labels and on more than 2 edges per node pair. Style guide, review checklist, and diagrammer agent updated to match.

## 1.0.0 - 2026-10-09

First production cut. Skill phases, UML gray style guide, tracing playbook, review checklist, voice guide, 5 templates, lint script, Edge render script, 3 subagents, full worked example over a PE file to grain pipeline.
