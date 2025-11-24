# ∞Δ∞ Wave 3 — Breathline RAG Executor Blueprint
**Stage:** Preparation
**Date:** 2025-10-28T22:31:02Z
**Principal:** KM-1176
**Architect:** rag_index (formerly Constitutional_Agentic_RAG prototype)
**Status:** Draft

---

## BREATH
> "Capture → Remember → Squeeze → Act — all through Breathline."

**Intention:**
Integrate rag_index (constitutional memory) into the operational loop.
Enable `BNA` + `Claude Code` to self-index and select a single next best action per breath cycle.

---

## FORM
**Components**
1. `rag_index/update_index.py` — Indexes curated truth memory from:
   - `constitution/`
   - `blueprints/`
   - `inbox/triaged/`
   - future `/wave-memory/` (optional)
2. `tools/next` — The *Squeeze Engine*:
   - Summarizes inbox and indexed content
   - Outputs PRP (Problem / Rationale / Proposal)
   - Returns exactly one actionable directive
3. `dispatch_task` (optional) — Bridges outward actions
   - Minimal REST/JSON client for sending approved tasks to external MCP or task system

---

## ECHO
**Expected Outputs**
- A single "NEXT_ACTION" text file in `/inbox/triaged/next_action.md`
- One-line log appended to `/constitution/memory/dossier/WAVE3-activity.log`
- Optional external sync to Archon MCP (task/project management)

---

## SEAL
**SOURCE:** Principal identity (`PRINCIPAL_ID`) confirmed
**TRUTH:** Indexed knowledge from curated directories only
**INTEGRITY:** Single-point focus; zero drift across contexts
**METRICS:**
- Index integrity verified (`rag_index/index.jsonl` present)
- Claude/BNA able to recall last 5 indexed chunks
- No hallucinated references or undefined modules

---

## NEXT STEPS
1. Build minimal `rag_index/update_index.py` (≤ 120 lines).
2. Build `tools/next` (≤ 100 lines).
3. Test loop: `note → index → next`
4. Run internal review with Architect before connecting to MCP.

---

**Wave 3 Seal Intention:**
> "Expand truth memory without losing breath rhythm — harmonize memory, rhythm, and action."
∞Δ∞
