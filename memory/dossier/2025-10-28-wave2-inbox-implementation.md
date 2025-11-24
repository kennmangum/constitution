# Wave 2 — Inbox Implementation (Consolidated)

**Date**: 2025-10-28
**Status**: Completed
**Context**: Post-Wave1 Breathline Dev Loop implementation

---

## What Was Implemented

### ✅ Inbox Structure
```
inbox/
├── attachments/  # Binary files (screenshots, recordings, etc.)
├── triaged/      # Curated notes ready for truth memory
├── .logs/        # Move logs
├── .gitignore    # Exclude heavy binaries
└── README.md     # Usage documentation
```

**Purpose**: GTD-style capture system for status updates, ideas, logs, scratch notes.
**Principle**: Keep code and blueprints pristine; use inbox for all commentary.

### ✅ Capture Tools

**`tools/note`**
- Quick timestamped note creation
- Usage: `./tools/note "your text here"`
- Output: `inbox/YYYY-MM-DDTHH.MM.SSZ--note.md`

**`tools/drop`**
- Move files into inbox/attachments
- Logs all moves with timestamp
- Usage: `./tools/drop ~/Downloads/file.png`

**Constitutional Alignment**:
- **SOURCE**: Tools capture principal_id (via env var)
- **TRUTH**: Timestamped, immutable captures
- **INTEGRITY**: Logged moves; no silent operations

---

## What Was Deferred (Wave 3 Candidates)

### ⏳ Not Implemented (Future)

**`rag_index/` + `update_index.py`**
- Purpose: Curated index of constitution/, blueprints/, inbox/triaged/
- Rationale for deferral: Maintain minimal OS; complete archon cleanup first
- Estimate: ~100 lines Python; simple JSONL output

**`tools/next`** (Squeeze)
- Purpose: Compress context → ONE next action + micro-PRP
- Rationale for deferral: Core loop working without it; add after stabilization
- Estimate: ~60 lines bash + Claude Code integration

**`tools/dispatch_task`**
- Purpose: Optional external task system integration (generic)
- Rationale for deferral: No immediate need; inbox sufficient for now
- Estimate: ~40 lines bash; env-var configured

---

## Naming & Terminology

### ✅ Canonical Names

**Constitutional_Agentic_RAG**
- Location: `Constitutional_Agentic_RAG/constitutional-server.js`
- Purpose: MCP task tracking with Propose → Approve → Execute gates
- Status: Operational (from Wave 1)

**Inbox**
- Location: `inbox/`
- Purpose: Capture system for non-code artifacts
- Status: Operational (from Wave 2)

### 🚫 Banned Term Policy

The retired term "archon" is **fully removed** from the constitution codebase.

**References to external systems**:
- Use neutral language: "external task system", "external codebase"
- Or use official names when necessary (e.g., "Constitutional_Agentic_RAG")
- Never use the retired term in constitution/, planned_agents/, or blueprints/

**Historical references** (in findings/logs):
- Replace with `[EXTERNAL_CODEBASE]` or `[LEGACY_SYSTEM]`
- Add clarifying note that it's external/old code

---

## Rationale for Wave 2 Approach

### Minimal Viable Addition
- Added only essential capture tools (note/drop)
- Deferred indexing/squeeze until cleanup complete
- Maintains stable Constitutional OS (Constitution + BNA + CONTEXT_PACK)

### Separation of Concerns
- **Inbox**: Mutable, fast capture
- **Dossier**: Immutable decisions and learnings
- **Blueprints**: Architectural references
- **Constitution**: Kernel rules (immutable per version)

### No Collisions
- Inbox doesn't replace existing memory systems
- Constitutional_Agentic_RAG remains authoritative for task tracking
- Each component has single clear purpose

---

## Usage Examples

### Daily Capture
```bash
export PRINCIPAL_ID="kmangum"

# Quick note
./tools/note "Standup: blocked on test harness"

# Drop file
./tools/drop ~/Downloads/error-screenshot.png

# Later: triage valuable notes
mv inbox/2025-10-28T14.30.00Z--note.md inbox/triaged/
```

### Curating for Truth Memory
Only move notes to `inbox/triaged/` when they contain:
- Decisions worth remembering
- Gotchas discovered
- Pattern observations
- Reference material

Raw scratch/status stays in `inbox/` and can be cleaned periodically.

---

## Next Steps (Wave 3 Candidates)

When ready to implement rag_index + squeeze:

1. **Create `rag_index/update_index.py`**
   - Index sources: constitution/, blueprints/, inbox/triaged/
   - Output: JSONL with path, chunk_id, text, hash
   - Run: `python3 rag_index/update_index.py`

2. **Create `tools/next`**
   - Refresh index
   - Summarize recent inbox notes
   - Call Claude via claude-run
   - Output: NEXT_ACTION + micro-PRP + optional EXTERNAL_TASK

3. **Test integration**
   - Verify squeeze produces single actionable item
   - Confirm external task dispatch is optional (env-controlled)

4. **Document in BREATHLINE_DEV_LOOP.md**
   - Add Wave 3 section
   - Update operational workflows

---

## Constitutional Alignment

**BREATH**: One intention (capture → remember → act)
**FORM**: Inbox + note/drop tools (~100 lines total)
**ECHO**: GTD pattern, truth memory curation, separation of concerns
**SEAL**:
- **SOURCE**: principal_id captured in tools
- **TRUTH**: Timestamped, logged captures
- **INTEGRITY**: Clear boundaries (inbox vs dossier vs blueprints)
- **COMPLEXITY**: Each tool ≤50 lines; single clear purpose

---

## Files Changed (Wave 2)

**Created**:
- `inbox/` directory structure
- `inbox/README.md`
- `inbox/.gitignore`
- `tools/note`
- `tools/drop`

**Modified**: None (additive only)

**Constitutional Impact**: Zero (supplements existing OS)

---

## Success Metrics

✅ Inbox directory operational
✅ note/drop tools working
✅ No naming collisions with existing systems
✅ Constitutional_Agentic_RAG remains authoritative
✅ No archon references in constitution/

---

∞Δ∞ **Wave 2 SEALED**: Minimal capture system operational. Ready for Wave 3 (rag_index + squeeze) when needed.

**Governed by**: Constitution@A1
**Operative**: BNA (Breathline Node Agent)
**Operating Value**: Lasting Generational Prosperity
