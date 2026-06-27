# Graph Report - myNixOS  (2026-06-27)

## Corpus Check
- 11 files · ~8,757 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 122 nodes · 112 edges · 13 communities (11 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `14601f9f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 12|Community 12]]

## God Nodes (most connected - your core abstractions)
1. `Azula Current Behavior Baseline` - 28 edges
2. `Azula Dendritic Migration Plan` - 12 edges
3. `Toph Graphics Progress` - 11 edges
4. `myNixOS` - 7 edges
5. `Decisions Already Made` - 6 edges
6. `Step List` - 6 edges
7. `Phase 1: Structural Migration On A VM Host First` - 6 edges
8. `Workstation Package Classification` - 6 edges
9. `Recommended Boundaries` - 4 edges
10. `Phase 5: Add Home Manager` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (13 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (28): Audio, Azula Current Behavior Baseline, Boot, Current NixOS Module List, Custom Emacs Build, Desktop Stack, Docker And Container Behavior, Enabled Programs (+20 more)

### Community 1 - "Community 1"
Cohesion: 0.14
Nodes (13): Azula Dendritic Migration Plan, Current Status, Decision Summary, Features, Goal, Hosts, Migration Strategy, Recommended Boundaries (+5 more)

### Community 2 - "Community 2"
Cohesion: 0.14
Nodes (14): Phase 2: Bring `azula` Onto The Proven Structure, Phase 3: Extract Clear Features From `azula`, Phase 4: Introduce User Boundaries, Phase 5: Add Home Manager, Step 10. Create `modules/users/fedex/default.nix`, `modules/users/ke/default.nix`, and `modules/users/jarvis/default.nix`, Step 11. Have hosts import only the users they need, Step 12. Add the Home Manager input and wire it into the flake, Step 13. Expand `modules/users/fedex/` to own personal configuration (+6 more)

### Community 3 - "Community 3"
Cohesion: 0.17
Nodes (11): Apply The Configuration, Change Made, Context, Current Outcome, Decision, Expected Behavior After Switch, Known Next Step, Toph Graphics Progress (+3 more)

### Community 4 - "Community 4"
Cohesion: 0.18
Nodes (9): Build And Verification, Critical Flake Gotcha, Current Architecture, Flake Structure, graphify, Naming Conventions, Repo Purpose, Source Of Truth (+1 more)

### Community 5 - "Community 5"
Cohesion: 0.29
Nodes (6): agent, build, general, model, model, $schema

### Community 6 - "Community 6"
Cohesion: 0.25
Nodes (7): Build, Current Status, myNixOS, Related Docs, Remote Bootstrap, Repository Layout, Workflow Notes

### Community 7 - "Community 7"
Cohesion: 0.33
Nodes (6): 1. Target pattern, 2. Scope, 3. User model, 4. Home Manager, 5. Naming convention, Decisions Already Made

### Community 8 - "Community 8"
Cohesion: 0.33
Nodes (6): Phase 1: Structural Migration On A VM Host First, Step 1. Capture the current `azula` behavior, Step 2. Create a thin top-level `flake.nix`, Step 3. Create `modules/parts.nix`, Step 4. Create `modules/hosts/my-machine/`, Step 5. Make the VM host build in the new structure

### Community 12 - "Community 12"
Cohesion: 0.29
Nodes (6): Categories, Inventory, Notes, Status Legend, Suggested First Exports, Workstation Package Classification

## Knowledge Gaps
- **93 isolated node(s):** `$schema`, `plugin`, `@opencode-ai/plugin`, `$schema`, `model` (+88 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Azula Dendritic Migration Plan` connect `Community 1` to `Community 2`, `Community 7`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `Step List` connect `Community 2` to `Community 8`, `Community 1`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **What connects `$schema`, `plugin`, `@opencode-ai/plugin` to the rest of the system?**
  _93 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._