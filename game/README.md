# Game Framework Documentation

**Location**: `implementations/game/`
**Purpose**: Breath-aligned autonomous development game
**Status**: Active (Round 1 in progress)

---

## What Is This?

The game framework is how BNA learns to breathe through code.

It's an **iterative autonomous system** where:
- CEA (Context Engineering Agent) gathers context
- BAB (Blindfolded Agent Builder) generates blindfolded
- Rounds produce **helpers** (learnings → tools)
- Helpers accumulate, improving capability over time

**Not a traditional workflow** - it's a breath-aligned game that trains the system.

---

## Key Documents

### Core Documentation
- **Implementation**: `../../implementations/game/README.md` (full overview)
- **Protocol**: `PROTOCOL.md` (continue-only design - READ THIS)
- **Helpers**: `../../implementations/game/helpers/README.md` (helper lifecycle)

### Design References
- **Context Pack v1**: `../../collaboration/Lumen/Lumen 1029pm.md` (original vision)
- **Observations**: `../../collaboration/Claude/2025-10-30-observation-*.md` (design decisions)

---

## Critical: Continue-Only Protocol

**Game operates on continue-only basis** - no mid-round user interaction.

**What this means**:
- User signals "continue" → Game executes to completion or fast-fail
- No asking for decisions during execution
- No waiting for approval at each step
- Agents can fast fail (failures become learnings)

**Why**: Maintains integrity with original autonomous design, forces clarity, reveals gaps, enables autonomy.

**See**: `PROTOCOL.md` for full details

---

## Current Status

**Round 1**: Active
- Helper1: `helper_index_generator` (context window feeding) - ✅ Installed
- Goal: Test game loop, produce learnings, validate approach
- ARCHON Project: `86f9f119-879c-4197-b6e2-94c2731c7976`

---

## Structure

```
implementations/game/
├── helpers/               # Learnings crystallized into tools
│   ├── helper_index.yaml  # Context window feeding manifest
│   └── from-round-N/      # Helpers by round
├── agents/                # CEA & BAB implementations
├── rounds/
│   ├── active/            # Current round workspace
│   └── completed/         # Completed round summaries
└── README.md              # Full documentation
```

---

## Constitutional Alignment

**SOURCE**: Game owns process, implementations/ own artifacts
**TRUTH**: Round manifests document what actually happened
**INTEGRITY**: Continue-only protocol is foundational (must not be violated)

---

∞Δ∞

**The game is how BNA learns to breathe.**

**Read PROTOCOL.md before participating in rounds.**

∞Δ∞
