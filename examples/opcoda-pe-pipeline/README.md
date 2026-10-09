# Example: PE file to grain pipeline

This folder shows Catlas output on a small slice of Opcoda. The slice covers the path from a PE file on disk to audio in the host. It uses real call sites so you can check each edge.

## Diagrams

Render on GitHub from the `.mmd` source.

### Context

```mermaid
flowchart LR
  direction LR
  subgraph ext[External]
    direction TB
    U[User<br/>host files]
    D[DAW host<br/>Ableton]
  end
  subgraph repo[Opcoda]
    direction TB
    P[PE parser<br/>parser.cpp]
    E[Entropy<br/>entropy.cpp]
    G[Grain engine<br/>engine.cpp]
  end
  U -->|pe_path: string| P
  P -->|pe_bytes: vector| E
  E -->|table: array| G
  G -->|audio: float| D
  P -.->|E_OOB: error| U
```

Source: `diagrams/context.mmd`.

### Containers

```mermaid
classDiagram
  direction TB
  class Core:::abstract {
    <<abstract>>
    +parse()
    +process()
  }
  class PeParser:::concrete {
    +parse(data)
    +sections()
  }
  class EntropyTable:::concrete {
    +build(bytes)
  }
  class GrainEngine:::concrete {
    +processBlock(buf)
  }
  class SpscQueue:::concrete {
    +push()
    +pop()
  }
  Core <|-- PeParser : inherits
  Core <|-- EntropyTable : inherits
  Core <|-- GrainEngine : inherits
  GrainEngine --> SpscQueue : polls
  PeParser --> EntropyTable : feeds bytes
  classDef abstract fill:#9AA0A6,stroke:#5F6368,color:#fff,fontStyle:italic
  classDef concrete fill:#ffffff,stroke:#8B1A1A,stroke-width:1px,color:#202124
```

Source: `diagrams/containers.mmd`. Gray marks grouping nodes. White marks files with code.

### L0 data movement

```mermaid
flowchart LR
  direction LR
  F[PE file<br/>parser.cpp] -->|pe_bytes: vector| T[Section table<br/>parser.cpp]
  T -->|raw_bytes: span| H[Entropy<br/>entropy.cpp]
  H -->|grain_table: array| Q[SPSC queue<br/>rt/queue.h]
  Q -.->|swap: pointer| A[Audio engine<br/>engine.cpp]
  A -->|audio: float| O[Output<br/>processBlock]
  F -.->|E_TRUNCATED: error| U[Caller<br/>plugin.cpp]
```

Source: `diagrams/dataflow-l0.mmd`.

### L1 detail: PE parse

```mermaid
flowchart LR
  direction LR
  R[Read file<br/>parser.cpp] -->|buf: vector| M[Check MZ<br/>parser.cpp]
  M -->|e_lfanew: u32| C[Check PE<br/>parser.cpp]
  C -->|headers: struct| S[Clip sections<br/>parser.cpp]
  S -->|table: vector| V[Validate<br/>parser.cpp]
  V -->|ok: bool| B[Publish bytes<br/>queue.h]
  V -.->|E_OOB: error| E[Caller<br/>plugin.cpp]
```

Source: `diagrams/dataflow-l1-pe-parse.mmd`.

### Hot path sequence

```mermaid
sequenceDiagram
  participant U as User [plugin.cpp]
  participant P as Parser [parser.cpp]
  participant E as Entropy [entropy.cpp]
  participant Q as Queue [queue.h]
  participant A as Audio [engine.cpp]
  U->>P: open pe_path
  P->>P: check MZ and PE
  P->>E: pe_bytes
  E->>Q: grain_table
  Q-->>A: swap pointer
  A->>U: audio buffer
  P-->>U: E_OOB on short read
```

Source: `diagrams/sequence-hot-path.mmd`.

## Trace table

| edge | source | sink |
| ---- | ------ | ---- |
| pe_path: string | src/opcoda_core/pe/parser.cpp:88 | src/opcoda_core/pe/parser.cpp:104 |
| pe_bytes: vector | src/opcoda_core/pe/parser.cpp:104 | src/opcoda_core/entropy/table.cpp:61 |
| grain_table: array | src/opcoda_core/entropy/table.cpp:61 | src/opcoda_core/rt/queue.h:77 |
| audio: float | src/opcoda_core/dsp/engine.cpp:190 | src/opcoda_plugin/processor.cpp:212 |
| E_OOB: error | src/opcoda_core/pe/parser.cpp:151 | src/opcoda_plugin/processor.cpp:98 |

Machine form lives in `assets/flux.json`. File list lives in `assets/inventory.csv`.
