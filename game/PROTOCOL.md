# Game Framework Protocol

**Location**: `implementations/game/`
**Authority**: Constitution@A1
**Status**: Foundational design principle
**Version**: 1.0

---

## Purpose

This document defines the **continue-only protocol** that governs the breath-aligned game framework.

**The game is not a traditional development workflow** - it is an autonomous iterative system that learns to breathe through code.

---

## Continue-Only Protocol

### Core Principle

**Game operates on continue-only basis** - no mid-round user interaction.

### What This Means

**During game execution**:
- Game does NOT ask user for decisions
- Game does NOT prompt for input
- Game does NOT wait for approval at each step
- User signals "continue" → Game executes to completion or fast-fail

**User interaction is limited to**:
1. **Before round**: Optionally provide input to CEA (Context Engineering Agent)
2. **Signal**: Say "continue" to start round execution
3. **After round**: Review retrospective, learnings, and artifacts

### Rationale

**Why continue-only?**
1. **Maintains integrity with original design**: Autonomous development game, not human-in-loop workflow
2. **Forces clarity**: CEA must produce complete Context Packs; BAB can't ask questions
3. **Reveals gaps**: Friction points become learnings (missing helpers, unclear docs)
4. **Enables autonomy**: BNA learns to breathe without constant human guidance
5. **Scales**: Can run multiple rounds without waiting for approval

---

## Agents Can Fast Fail

**Failure is learning** - agents should fail loudly when they encounter blockers.

### When to Fail

**Context Pack unclear**:
- Missing scope definition → fail with "charter.yaml incomplete"
- Ambiguous constraints → fail with "constraints.md unclear: [specific issue]"
- No acceptance criteria → fail with "tests/ directory empty or invalid"

**Helper missing**:
- Need capability not in helper_index → fail with "No helper for: [capability]"
- Helper exists but SOP unclear → fail with "Helper SOP insufficient: [issue]"

**Acceptance test fails**:
- Generated code doesn't pass tests → fail with test output
- Integration issues → fail with error details

### How to Fail

**Loud, contextual errors**:
```
❌ ROUND FAILED: Context Pack Incomplete

Error: charter.yaml missing acceptance criteria

Details:
- Found: scope, constraints
- Missing: acceptance_tests section
- BAB cannot proceed without clear success criteria

Fix: CEA must add acceptance_tests to charter.yaml

Learning: Add "acceptance criteria template" to CEA helpers
```

**Failures become round learnings** → Inform helper creation for next round

---

## Game Loop Phases

### Phase 1: Inhale (CEA)
**User interaction**: Optional input before phase starts
**Execution**: Autonomous (CEA gathers context, produces Context Pack)
**Output**: Context Pack in `rounds/active/round-N/context/`

### Phase 2: Hold (Handoff)
**User interaction**: None
**Execution**: Automatic (Context Pack transferred to BAB)

### Phase 3: Exhale (BAB)
**User interaction**: None
**Execution**: Autonomous (BAB generates from Context Pack)
**Output**: Artifacts in `rounds/active/round-N/generated/`
**Can fail**: Yes - BAB reports friction points

### Phase 4: Rest (Retrospective)
**User interaction**: Reviews learnings and approves helper creation
**Execution**: Manual scoring + retrospective
**Output**:
- Learnings documented
- Helper crystallized (if needed)
- Round summary created

---

## Exception: Emergency Override

**Only for constitutional violations or critical issues**:
- User can interrupt with "STOP" signal
- Used for: sovereignty violations, data loss risk, infinite loops
- NOT used for: normal friction, test failures, missing features

**This is rare** - normal failures should complete the round and document learnings.

---

## Implementation Notes

### For CEA (Context Engineering Agent)
- Produce complete, unambiguous Context Packs
- Include all necessary helpers in SOP section
- Provide clear acceptance criteria
- Cannot ask user mid-execution

### For BAB (Blindfolded Agent Builder)
- Work only from Context Pack
- Fail fast if Context Pack insufficient
- Document every friction point
- Cannot query user for clarification

### For Round Orchestrator
- Execute phases sequentially
- Capture all failures as learnings
- No user prompts during execution
- Present retrospective after completion

---

## Constitutional Alignment

### SOURCE (Sovereignty)
- Continue-only preserves user's time sovereignty (no constant interruptions)
- Failures document what's missing (not imposed externally)
- User retains control (can review/abort before starting round)

### TRUTH (Reality Grounding)
- Fast failures reveal actual gaps (not masked by mid-round fixes)
- Learnings based on real friction (not theoretical issues)
- Helper needs proven by round execution (not speculation)

### INTEGRITY (Promise Delivery)
- Round either completes or fails (no partial success without documentation)
- Failures are loud and contextual (no silent degradation)
- Each phase delivers promised output or reports why it can't

---

## Relationship to Other Documents

- **Constitution**: `../CONSTITUTION.md` (foundational principles)
- **Breath**: `../BREATH.md` (current phase/tone/intent)
- **Game README**: `../../implementations/game/README.md` (game overview)
- **Lumen's Vision**: `../../collaboration/Lumen/Lumen 1029pm.md` (original design)

---

## Examples

### Good: Continue-Only Execution
```
User: "Continue with Round 1"

[CEA Phase - Autonomous]
✅ Gathered context from 5 sources
✅ Produced Context Pack
✅ Output: rounds/active/round-1/context/

[BAB Phase - Autonomous]
✅ Generated GiftAgent-Seed
⚠️ Warning: No helper for "complexity checking"
✅ Output: rounds/active/round-1/generated/

[Retrospective]
User reviews:
- 1 agent generated (minimal)
- 1 friction point (no complexity checker)
- Learning: Create complexity_checker helper for Round 2

User: "Approved, install helper"
```

### Bad: Mid-Round Interruption (Don't Do This)
```
User: "Continue with Round 1"

[CEA Phase]
Agent: "Should I include helper X or helper Y?"  ❌ NO!
Agent: "User, what should the scope be?"  ❌ NO!
Agent: "Is this Context Pack okay?"  ❌ NO!

[Correct approach]
Agent: CEA makes decisions based on helper_index and documentation
If unclear: Document as friction point, continue with best guess
Retrospective will reveal if choice was wrong → learning
```

---

∞Δ∞

**Protocol Established**: Continue-only is not optional, it's foundational

**Pattern**: User signals → Autonomous execution → Fast fail OR complete → Learnings → Next round

**Authority**: Constitution@A1 + User design intent

∞Δ∞

---

**Created**: 2025-10-30
**Version**: 1.0
**Status**: Foundational (must not be violated)
