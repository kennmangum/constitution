# RAG_Index: Constitutional Memory — TRUTH Anchor

**Date**: 2025-10-31
**Classification**: Constitutional Memory (TRUTH Anchor)
**Prior Misclassification**: External resource (incorrect)
**Authority**: Lumen guidance, BNA observation

---

## Summary

RAG_Index (`rag_index/`) is **constitutional memory**, not an external resource. It serves as a TRUTH anchor — indexed knowledge created by and for the system itself.

---

## Classification Under Constitutional Triad

### TRUTH (Primary Role)

RAG_Index stores vectorized, searchable representations of:
- Constitutional documents (CONSTITUTION.md, profiles, essence)
- Blueprints and architectural references
- Dossier entries and decision history
- Implementation documentation
- Collaboration notes and guidance

**Purpose**: Enable fast, semantically-aware retrieval of constitutional knowledge across sessions.

### SOURCE (Ownership)

- **Created by**: System-generated (indexing process)
- **Owned by**: Principal (kmangum/KM-1176)
- **Scope**: Single-principal (sovereignty maintained)

### INTEGRITY (Consistency)

- **Update protocol**: Re-index after significant commits
- **Validation**: Manifest tracks indexed sources
- **Referential integrity**: Index points to actual files (must resolve)

---

## Operations Classification

### Unbound (Observation)

**RAG Queries** — Read-only TRUTH retrieval:
```python
# Examples of unbound RAG operations
mcp__archon__rag_search_knowledge_base(query="sovereignty pattern")
mcp__archon__rag_read_full_page(page_id="...")
mcp__archon__rag_list_pages_for_source(source_id="...")
mcp__archon__rag_get_available_sources()
```

**Rationale**: Reading indexed knowledge is observation, not mutation. No approval required.

### Gated (Mutation)

**RAG Indexing** — State mutation:
- Creating new index entries
- Re-vectorizing content
- Updating manifest
- Deleting stale entries

**Rationale**: Writing to index changes persistent state. Requires approval or explicit protocol.

---

## Directory Structure

```
rag_index/
├── index.jsonl          # Vector embeddings (gitignored, regenerated)
├── manifest.json        # Source tracking (committed)
├── traces/              # Operation logs (gitignored)
│   └── 2025-10-31.jsonl
└── README.md            # Documentation
```

**What's committed**:
- `manifest.json` — Canonical record of indexed sources
- `README.md` — Usage documentation

**What's gitignored**:
- `index.jsonl` — Generated embeddings (large, regenerable)
- `traces/` — Operational logs (ephemeral)

---

## Cross-Session Persistence

**Problem**: Each new BNA session rebuilds context from canonical files. Without RAG_Index, nuanced knowledge from prior sessions would be lost.

**Solution**: RAG_Index serves as searchable constitutional memory:
1. After significant work, index new documents
2. On session start, query RAG for relevant context
3. Retrieve full pages when needed
4. Build context from indexed truth, not just files

**Example Flow**:
```
New Session Start
    ↓
Load Frequency Nest (Constitution, BNA, Breathline Core, BREATH, Context Pack)
    ↓
Query RAG: "What sovereignty patterns exist?"
    ↓
Retrieve relevant pages
    ↓
Build informed context without re-reading all files
```

---

## Instance Coordination

**Canonical**: `manifest.json` syncs via git pull
**Ephemeral**: `index.jsonl` regenerated per instance

When RTX 5090 instance pulls latest git state:
1. `manifest.json` arrives (canonical source list)
2. Re-index locally to rebuild `index.jsonl`
3. Each instance has local embeddings, shared manifest

**Benefit**: Reduces git repo size (embeddings not committed), maintains TRUTH consistency (manifest committed).

---

## Indexing Protocol (Proposed)

### When to Re-Index

**Automatic** (if tooling supports):
- After commits with constitutional changes
- Daily at midnight (batch update)

**Manual** (on request):
- After significant knowledge additions
- Before complex research tasks
- When context feels incomplete

### What to Index

**Priority 1** (always):
- `constitution/` (all subdirectories)
- `collaboration/Lumen/` (guidance)
- `collaboration/KM-1176/` (principal notes)

**Priority 2** (selective):
- `implementations/game/` (framework knowledge)
- `blueprints/` (architectural references)
- `examples/` (learning materials)

**Priority 3** (on-demand):
- `collaboration/BNA/journal/` (ephemeral traces)
- `tools/` (implementation details)

---

## Correction from Prior Context Description

### Before (Incorrect)

```markdown
External (via MCP):
  - Archon (persistent memory, projects, tasks)
  - RAG index (knowledge base search)
```

**Problem**: Implied RAG_Index is external/optional, when it's actually core constitutional memory.

### After (Correct)

```markdown
Constitutional Memory:
  - Dossier (constitution/memory/dossier/) - Decision history
  - Housekeeping (constitution/memory/housekeeping/) - Session notes
  - RAG_Index (rag_index/) - Searchable TRUTH anchor

Knowledge Access (via MCP):
  - Archon RAG tools (mcp__archon__rag_*) - Query interface to RAG_Index
  - Archon Projects/Tasks (mcp__archon__find_*, manage_*) - Workflow tracking
```

**Fix**: RAG_Index is constitutional infrastructure, MCP tools are the access interface.

---

## Constitutional Alignment

### SOURCE
- ✅ Owned by principal (kmangum/KM-1176)
- ✅ Scoped to single instance (per-deployment)
- ✅ Sovereignty maintained (no external dependency)

### TRUTH
- ✅ References resolve (manifest points to actual files)
- ✅ Searchable reality (semantic queries work)
- ✅ Cross-session persistence (knowledge survives restarts)

### INTEGRITY
- ✅ Clear operations (query=unbound, index=gated)
- ✅ Manifest tracked in git (canonical source list)
- ✅ Regenerable embeddings (not sacred, rebuildable)

---

## Remediation Complete

**Actions Taken**:
1. ✅ Created this dossier entry (constitutional memory documentation)
2. ⏳ Update CONTEXT_PACK.yaml (next action)
3. ⏳ Future context descriptions will correctly classify RAG_Index

**Verification**:
- RAG queries will be understood as unbound observation (TRUTH retrieval)
- RAG indexing will be proposed as gated mutation (state change)
- Cross-session knowledge will flow through constitutional memory, not "external" sources

---

**Created**: 2025-10-31
**Status**: Complete (observation documented, classification corrected)
**Next**: Update CONTEXT_PACK.yaml to reflect this understanding

∞Δ∞ **SEAL**: RAG_Index reclassified as constitutional memory — TRUTH anchor operational.

**Operating Value**: Lasting Generational Prosperity
**Rhythm**: Breath → Form → Echo → Seal
