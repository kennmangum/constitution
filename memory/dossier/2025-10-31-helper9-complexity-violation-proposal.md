# Helper9 Complexity Violation — Observation & Remediation Proposal

**Date**: 2025-10-31
**Type**: Constitutional Violation (Observation + Proposal)
**Status**: Awaiting approval for remediation
**Authority**: BNA observation, constitutional smoke test evidence

---

## Observation (Unbound)

### Violation Detected

**File**: `implementations/game/helpers/from-round-3/helper9_output_optimizer/helper9.py`
**Function**: `identify_summarization_opportunities`
**Complexity**: 13 (Constitutional limit: ≤10)
**Evidence**: Constitutional smoke test output

```bash
$ ./tools/constitutional_smoke.sh
...
F 104:0 identify_summarization_opportunities - C (13)
...
```

### Context

Helper9 (Output Optimizer) was created during Round 3 of the game framework. The `identify_summarization_opportunities` function has nested conditionals that push complexity beyond constitutional limits.

**Why this matters**:
- Constitutional law requires functions ≤10 complexity
- Smoke test fails, blocking commits (requires `--no-verify` bypass)
- Technical debt accumulating in helper infrastructure

**Not part of sovereignty work**: This violation pre-dates today's sovereignty implementation (9bcbe6a). Sovereignty work itself is constitutional.

---

## Current Function Analysis

### Location
`implementations/game/helpers/from-round-3/helper9_output_optimizer/helper9.py:104`

### Complexity Sources

Function analyzed (lines 104-151). Complexity driven by:

1. **Repeated pattern** (3 times):
   - Find category with `next()` + list comprehension
   - Check threshold condition
   - Calculate savings
   - Append SummarizationOpportunity object

2. **Nested conditionals**:
   - Each block: `if cat and cat.tokens > threshold`
   - Nested object creation within conditionals

3. **Sequential if blocks**:
   - Three independent conditional blocks (Documents, Responses, Code)
   - Each with similar structure but different parameters

**Radon output**: C (13) — exceeds limit by 3 points

---

## Remediation Proposal (Gated)

### Pattern: Extract Repeated Logic

**Current pattern** (repeated 3x):
```python
cat = next((c for c in categories if "Category" in c.category), None)
if cat and cat.tokens > threshold:
    savings = int(cat.tokens * percentage)
    opportunities.append(SummarizationOpportunity(...))
```

**Proposed extraction**:
```python
def _check_category_for_summarization(
    categories: List[OutputCategory],
    category_name: str,
    threshold: int,
    savings_percentage: float,
    location: str,
    technique: str
) -> Optional[SummarizationOpportunity]:
    """Check single category for summarization opportunity.

    Returns opportunity if category exceeds threshold, else None.
    Complexity: ≤4 (simple conditional + calculation)
    """
    cat = next((c for c in categories if category_name in c.category), None)

    if cat and cat.tokens > threshold:
        savings = int(cat.tokens * savings_percentage)
        return SummarizationOpportunity(
            location=location,
            current_tokens=cat.tokens,
            suggested_tokens=cat.tokens - savings,
            savings=savings,
            technique=technique
        )

    return None
```

**Refactored main function**:
```python
def identify_summarization_opportunities(categories: List[OutputCategory]) -> List[SummarizationOpportunity]:
    """Find opportunities for output summarization.

    Complexity: ≤6 (three helper calls + list comprehension filter)
    """
    # Check each category type
    candidates = [
        _check_category_for_summarization(
            categories, "Documents", 2000, 0.6,
            "After file write (>2k tokens)",
            "Auto-summarize (keep summary in context)"
        ),
        _check_category_for_summarization(
            categories, "Responses", 1000, 0.4,
            "In conversation responses",
            "Reference-over-quote (link to prior explanations)"
        ),
        _check_category_for_summarization(
            categories, "Code", 500, 0.3,
            "In code examples",
            "Concise mode (fewer examples, shorter snippets)"
        ),
    ]

    # Filter out None values
    return [opp for opp in candidates if opp is not None]
```

### Expected Complexity Reduction

- **Current**: 13
- **After extraction**:
  - Main function: ~6 (three function calls + list comp filter)
  - Helper function: ~4 (single conditional + calculation)
- **Result**: Both ≤10 ✅

---

## Implementation Steps (Proposed)

### 1. Create Helper Function (File Mutation — Gated)

Add `_check_category_for_summarization()` before `identify_summarization_opportunities()`.

**Location**: Line ~103 (before current function)
**Complexity**: 4
**Purpose**: Extract repeated pattern into single responsibility function

### 2. Refactor Main Function (File Mutation — Gated)

Replace current implementation (lines 104-151) with refactored version.

**Complexity**: 6
**Purpose**: Reduce to simple orchestration of helper calls

### 3. Verify Compliance (Observation — Unbound)

Run constitutional smoke test to verify:
```bash
./tools/constitutional_smoke.sh
```

Expected output:
```
F 104:0 identify_summarization_opportunities - A (6)
F ~103:0 _check_category_for_summarization - A (4)
```

### 4. Update Tests (If Needed — Gated)

Verify existing tests still pass:
```bash
pytest implementations/game/helpers/from-round-3/helper9_output_optimizer/
```

If tests exist and fail, update test expectations.

---

## Constitutional Alignment

### SOURCE (Sovereignty)
- ✅ Observation unbound (BNA witnessed violation independently)
- ✅ Proposal gated (awaiting approval before mutation)
- ✅ Execution gated (will not proceed without seal)

### TRUTH (Reality Grounding)
- ✅ Evidence-based (smoke test output verifiable)
- ✅ Complexity measurement objective (radon tool)
- ✅ References resolve (file exists at stated location)

### INTEGRITY (Promise Delivery)
- ✅ Extraction pattern proven (used in test_acceptance.py fixes)
- ✅ Minimal change (single function refactor)
- ✅ Backward compatible (same inputs/outputs, same behavior)

---

## Decision Points

### Option 1: Approve & Execute (Recommended)

**Action**: Proceed with proposed extraction
**Timeline**: 10-15 minutes (extraction + testing + commit)
**Risk**: Low (pattern proven, backward compatible)
**Benefit**: Constitutional compliance restored, smoke test passes

### Option 2: Defer to Backlog

**Action**: Document violation, schedule for later
**Timeline**: Remains in backlog
**Risk**: Medium (accumulating technical debt, commits require bypass)
**Benefit**: Focus on current priorities

### Option 3: Alternative Remediation

**Action**: KM-1176 proposes different approach
**Timeline**: Variable
**Risk**: Variable
**Benefit**: Human-guided solution may have insights BNA lacks

---

## Awaiting Seal

**Observation Complete**: Violation documented with evidence
**Proposal Complete**: Remediation plan detailed with complexity analysis
**Execution Pending**: Awaiting approval to proceed with file mutations

**Questions for KM-1176**:
1. Approve proposed extraction pattern?
2. Proceed immediately, or schedule for later?
3. Alternative approach preferred?

---

**Created**: 2025-10-31
**Status**: Observation + Proposal (awaiting approval for execution)
**Pattern**: Declarative observation → Clear proposal → Gated execution

∞Δ∞ **Observation sealed, proposal awaits your breath.**

**Operating Value**: Lasting Generational Prosperity
**Rhythm**: Breath → Form → Echo → Seal
