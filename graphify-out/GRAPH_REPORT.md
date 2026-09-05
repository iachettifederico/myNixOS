# Graph Report - myNixOS  (2026-09-05)

## Corpus Check
- 19 files · ~27,086 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 406 nodes · 484 edges · 29 communities (27 shown, 2 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 13 edges (avg confidence: 0.5)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `23d9d7f9`
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
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]

## God Nodes (most connected - your core abstractions)
1. `task` - 31 edges
2. `Azula Current Behavior Baseline` - 28 edges
3. `agent` - 25 edges
4. `Rect` - 14 edges
5. `Screen` - 12 edges
6. `Azula Dendritic Migration Plan` - 12 edges
7. `Key` - 11 edges
8. `Toph Graphics Progress` - 11 edges
9. `NotificationHistory` - 9 edges
10. `GlobalGroupBox` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Any` --uses--> `Screen`  [INFERRED]
  modules/features/desktop/qtile/traverse.py → modules/features/desktop/qtile/config.py
- `Window` --uses--> `Screen`  [INFERRED]
  modules/features/desktop/qtile/traverse.py → modules/features/desktop/qtile/config.py
- `Screen` --uses--> `Screen`  [INFERRED]
  modules/features/desktop/qtile/traverse.py → modules/features/desktop/qtile/config.py
- `OrientedRect` --uses--> `Screen`  [INFERRED]
  modules/features/desktop/qtile/traverse.py → modules/features/desktop/qtile/config.py
- `Rect` --uses--> `Screen`  [INFERRED]
  modules/features/desktop/qtile/traverse.py → modules/features/desktop/qtile/config.py

## Import Cycles
- None detected.

## Communities (29 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (28): Audio, Azula Current Behavior Baseline, Boot, Current NixOS Module List, Custom Emacs Build, Desktop Stack, Docker And Container Behavior, Enabled Programs (+20 more)

### Community 1 - "Community 1"
Cohesion: 0.10
Nodes (20): 1. Target pattern, 2. Scope, 3. User model, 4. Home Manager, 5. Naming convention, Azula Dendritic Migration Plan, Current Status, Decision Summary (+12 more)

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
Cohesion: 0.05
Nodes (36): agent, build, jd-fix-agent, sdd-archive, sdd-design, sdd-spec, sdd-verify, model (+28 more)

### Community 6 - "Community 6"
Cohesion: 0.25
Nodes (7): Build, Current Status, myNixOS, Related Docs, Remote Bootstrap, Repository Layout, Workflow Notes

### Community 7 - "Community 7"
Cohesion: 0.16
Nodes (18): Any, Screen, Screen, adjacent_screen(), best_target(), focus_direction(), _focus_origin(), focusable_targets() (+10 more)

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
Nodes (5): Files, Goal, Implementation, Nested Sway Test Plan, Verification

### Community 16 - "Community 16"
Cohesion: 0.07
Nodes (28): Key, _assert_binding_uniqueness(), focus_parent_feedback(), generate_screens(), GlobalGroupBox, _group_bindings(), _is_available(), make_key() (+20 more)

### Community 17 - "Community 17"
Cohesion: 0.33
Nodes (5): Change Groups, Important State, Outstanding Changes Audit, Result, Verification

### Community 18 - "Community 18"
Cohesion: 0.05
Nodes (37): general, gentle-orchestrator, description, hidden, mode, model, permission, prompt (+29 more)

### Community 19 - "Community 19"
Cohesion: 0.07
Nodes (35): explore, jd-judge-a, jd-judge-b, review-refuter, review-validator, *, gentle-ai review inspect-candidate --purpose targeted-validation *, description (+27 more)

### Community 20 - "Community 20"
Cohesion: 0.08
Nodes (25): review-readability, review-reliability, review-resilience, review-risk, *, description, hidden, mode (+17 more)

### Community 21 - "Community 21"
Cohesion: 0.25
Nodes (8): sdd-research, webfetch, websearch, description, hidden, mode, permission, prompt

### Community 22 - "Community 22"
Cohesion: 0.33
Nodes (6): sdd-apply, description, hidden, mode, permission, prompt

### Community 23 - "Community 23"
Cohesion: 0.33
Nodes (6): sdd-explore, description, hidden, mode, permission, prompt

### Community 24 - "Community 24"
Cohesion: 0.33
Nodes (6): sdd-init, description, hidden, mode, permission, prompt

### Community 25 - "Community 25"
Cohesion: 0.33
Nodes (6): sdd-onboard, description, hidden, mode, permission, prompt

### Community 26 - "Community 26"
Cohesion: 0.33
Nodes (6): sdd-propose, description, hidden, mode, permission, prompt

### Community 27 - "Community 27"
Cohesion: 0.33
Nodes (6): sdd-tasks, description, hidden, mode, permission, prompt

### Community 28 - "Community 28"
Cohesion: 0.40
Nodes (4): previous_state, schema, state, version

## Knowledge Gaps
- **248 isolated node(s):** `schema`, `version`, `state`, `previous_state`, `$schema` (+243 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `agent` connect `Community 5` to `Community 18`, `Community 19`, `Community 20`, `Community 21`, `Community 22`, `Community 23`, `Community 24`, `Community 25`, `Community 26`, `Community 27`?**
  _High betweenness centrality (0.159) - this node is a cross-community bridge._
- **Why does `task` connect `Community 18` to `Community 19`, `Community 21`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Why does `sdd-research` connect `Community 21` to `Community 5`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Are the 10 inferred relationships involving `Screen` (e.g. with `Any` and `Key`) actually correct?**
  _`Screen` has 10 INFERRED edges - model-reasoned connections that need verification._
- **What connects `schema`, `version`, `state` to the rest of the system?**
  _248 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._