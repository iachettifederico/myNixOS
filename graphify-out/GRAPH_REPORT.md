# Graph Report - myNixOS  (2026-08-20)

## Corpus Check
- 16 files · ~10,347 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 147 nodes · 132 edges · 17 communities (14 shown, 3 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `96820454`
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
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]

## God Nodes (most connected - your core abstractions)
1. `Azula Current Behavior Baseline` - 28 edges
2. `Azula Dendritic Migration Plan` - 12 edges
3. `Toph Graphics Progress` - 11 edges
4. `myNixOS` - 7 edges
5. `Prevent Root Filesystem Exhaustion` - 6 edges
6. `Decisions Already Made` - 6 edges
7. `Step List` - 6 edges
8. `Phase 1: Structural Migration On A VM Host First` - 6 edges
9. `Workstation Package Classification` - 6 edges
10. `Skill Registry — myNixOS` - 5 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (17 total, 3 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (28): Audio, Azula Current Behavior Baseline, Boot, Current NixOS Module List, Custom Emacs Build, Desktop Stack, Docker And Container Behavior, Enabled Programs (+20 more)

### Community 1 - "Community 1"
Cohesion: 0.14
Nodes (13): Azula Dendritic Migration Plan, Current Status, Decision Summary, Features, Goal, Hosts, Migration Strategy, Recommended Boundaries (+5 more)

### Community 2 - "Community 2"
Cohesion: 0.10
Nodes (20): Phase 1: Structural Migration On A VM Host First, Phase 2: Bring `azula` Onto The Proven Structure, Phase 3: Extract Clear Features From `azula`, Phase 4: Introduce User Boundaries, Phase 5: Add Home Manager, Step 10. Create `modules/users/fedex/default.nix`, `modules/users/ke/default.nix`, and `modules/users/jarvis/default.nix`, Step 11. Have hosts import only the users they need, Step 12. Add the Home Manager input and wire it into the flake (+12 more)

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
Cohesion: 0.29
Nodes (6): Diagnosis, Files, Implementation, One-Time Cleanup, Prevent Root Filesystem Exhaustion, Verification

### Community 12 - "Community 12"
Cohesion: 0.29
Nodes (6): Categories, Current Top-Level Modules, Inventory, Notes, Status Legend, Workstation Package Classification

### Community 13 - "Community 13"
Cohesion: 0.33
Nodes (5): Critical File, Goal, Implementation, Sofi Spanish Locale On Toph, Verification

### Community 14 - "Community 14"
Cohesion: 0.50
Nodes (3): Gentle AI Release Check, Result, Verification

### Community 15 - "Community 15"
Cohesion: 0.33
Nodes (5): Contract, Loading protocol, Skill Registry — myNixOS, Skills, Sources scanned

## Knowledge Gaps
- **109 isolated node(s):** `fingerprint`, `$schema`, `plugin`, `@opencode-ai/plugin`, `$schema` (+104 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Azula Dendritic Migration Plan` connect `Community 1` to `Community 2`, `Community 7`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **Why does `Step List` connect `Community 2` to `Community 1`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **What connects `fingerprint`, `$schema`, `plugin` to the rest of the system?**
  _109 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._