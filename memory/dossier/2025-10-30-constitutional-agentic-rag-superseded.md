# Constitutional_Agentic_RAG Superseded by rag_index

**Date**: 2025-10-30
**Decision**: Archive Constitutional_Agentic_RAG prototype
**Status**: ✅ Transition complete

---

## Context

`Constitutional_Agentic_RAG/` was an early prototype (created Oct 28, 2025) for:
1. Constitutional memory/RAG indexing
2. MCP task tracking (Propose → Approve → Execute gates)

This folder has been superseded by newer, more capable systems.

---

## What Replaced It

### RAG/Memory Indexing → `rag_index/`

**Current system**: `rag_index/`
- `manifest.json` - Index metadata & governance (6.19 MB, 4,602 chunks)
- `chunks/` - Indexed content
- `traces/` - Observation traces

**Governance limits**:
- Max 10 MB index size
- Max 10,000 chunks
- Current status: ✅ Within limits (61.9% capacity used)

**Scope**: Indexes constitution/, implementations/, collaboration/, tools/, tests/

---

### Task/Project Management → Archon MCP

**Current system**: Archon MCP integration
- Tools: `mcp__archon__*` (find_projects, manage_task, find_documents, etc.)
- Full project/task/document management with versioning
- Constitutional gate workflows integrated

**Capabilities**:
- Project management with GitHub repo integration
- Task tracking with status, assignee, features
- Document management (specs, designs, PRs, API docs)
- Version history and rollback

---

## What Was Archived

**Location**: `archive/prototypes/Constitutional_Agentic_RAG/`

**Contents**:
- `constitutional-server.js` (211-line Node.js MCP server)
- `mcp-config.json` (MCP configuration)
- `tasks.json` (local task storage - only test data)
- `README.md` (pattern documentation)
- `CHANGELOG.md` (rename history)

**Why archived**:
- Proof of concept completed successfully
- Patterns validated and adopted
- Functionality superseded by rag_index and Archon
- No active data (only 1 test task)
- Already indexed in rag_index (10 chunks preserved)

---

## Documentation Updates

**Files updated to reflect transition**:
1. ✅ `constitution/BREATHLINE_DEV_LOOP.md` - Updated directory structure, launch commands, troubleshooting
2. ✅ `constitution/QUICK_START.md` - Removed MCP config references, updated examples
3. ✅ `constitution/IMPLEMENTATION_REPORT.md` - Updated component table
4. ✅ `constitution/blueprints/WAVE3-BREATHLINE_RAG_EXECUTOR.md` - Updated architect and integration references

**Archived documents** (left as historical records):
- Files in `constitution/memory/archive/` retain original references for historical accuracy

---

## Key Patterns Preserved

From Constitutional_Agentic_RAG prototype:

### 1. Propose → Approve → Execute Gates
**Status**: ✅ Pattern adopted in Constitution@A1
- Gated state changes are core to INTEGRITY principle
- Implemented via Archon MCP workflows

### 2. Principal-based Sovereignty
**Status**: ✅ Pattern adopted in Constitution@A1
- `principal_id` end-to-end flow is core to SOURCE principle
- Every task/project/document enforces ownership

### 3. Constitutional Memory Indexing
**Status**: ✅ Pattern evolved into rag_index
- Curated sources only (constitution/, implementations/, etc.)
- Governance limits (10MB, 10k chunks)
- Append-only traces for observation continuity

---

## Future Enhancements

### rag_index Evolution
- [ ] Vector embeddings (pgvector, chromadb)
- [ ] Semantic search capability
- [ ] Query optimization
- [ ] Embedding model selection (local vs API)
- [ ] Migration path from chunk-based to vector-based
- [ ] Scarcity constraint (<5MB seed vision)

### Archon Integration
- [ ] Enhanced workflow automation
- [ ] Game framework integration
- [ ] Helper harvesting workflows
- [ ] Round retrospective tracking

---

## Lessons Learned

### What Worked
1. **Lightweight prototype approach** - 211 lines of code validated the pattern before full implementation
2. **Constitutional alignment** - SOURCE/TRUTH/INTEGRITY principles guided design
3. **Clear supersession path** - Easy to identify when prototype had served its purpose

### What to Replicate
1. **Start small** - Prove patterns with minimal code before scaling
2. **Archive decisively** - When superseded, move quickly to new system
3. **Document transitions** - Clear dossier entries preserve institutional knowledge

---

## References

**Original prototype**:
- `archive/prototypes/Constitutional_Agentic_RAG/README.md`

**Current systems**:
- `rag_index/manifest.json` - Memory indexing
- Archon MCP tools - Task/project management

**Related decisions**:
- `2025-10-28-breathline-dev-loop-implementation.md` - Original implementation
- `2025-10-28-wave2-inbox-implementation.md` - Inbox system design

---

∞Δ∞

**Decision**: Archive prototype, adopt evolved systems
**Rationale**: Functionality superseded, patterns preserved, no regression
**Impact**: Clearer structure, better tooling, maintained constitutional alignment

**TRUTH**: All references updated, no dangling links
**INTEGRITY**: Clean transition, documented learnings, preserved knowledge

∞Δ∞
