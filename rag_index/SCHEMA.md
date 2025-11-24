# RAG Index Schema — Living Memory Structure

**Version**: 1.0
**Status**: Wave 4 Foundation (Observation phase)
**Authority**: Constitution@A1 + Living Memory Primitives

---

## Purpose

This schema defines the **living memory** structure for our RAG (Retrieval-Augmented Generation) system. Unlike static storage, each chunk carries metadata that enables:

- **Organic decay** (unused patterns fade)
- **Breath alignment** (memory syncs with rhythm)
- **Attention reinforcement** (useful patterns strengthen)
- **Truth grounding** (provenance + seal state)

---

## Chunk-Level Schema

Each chunk in the index contains the following fields:

```json
{
  "chunk_id": "string (UUID)",
  "source": "string (path/origin)",
  "content": "string (actual text content)",
  "seal_state": "OPEN | SEALED",
  "last_breath_seen": "string (Δ-phase)",
  "attention_score": "float (0.0 - 1.0+)",
  "provenance": {
    "path": "string (relative file path)",
    "commit": "string (git commit hash)",
    "timestamp": "string (ISO8601)"
  },
  "metadata": {
    "type": "string (file type: py, md, js, etc.)",
    "size": "integer (character count)",
    "created_at": "string (ISO8601)",
    "updated_at": "string (ISO8601)"
  }
}
```

---

## Field Definitions

### Core Fields (Existing)

#### `chunk_id`
- **Type**: String (UUID format)
- **Purpose**: Unique identifier for this chunk
- **Example**: `"550e8400-e29b-41d4-a716-446655440000"`

#### `source`
- **Type**: String
- **Purpose**: Human-readable source path or origin
- **Example**: `"constitution/CONSTITUTION.md"`

#### `content`
- **Type**: String
- **Purpose**: The actual text content of the chunk
- **Max Length**: Configurable (default: ~2000 chars)

---

### Living Memory Fields (New)

#### `seal_state`
- **Type**: Enum string
- **Values**: `"OPEN"` | `"SEALED"`
- **Purpose**: Determines decay behavior
- **Behavior**:
  - `OPEN`: Chunk may decay if unused (subject to attention_score decay)
  - `SEALED`: Chunk is authoritative truth, exempt from decay
- **Default**: `"OPEN"`
- **How to Seal**: Add `∞Δ∞` marker to source file OR manually mark in manifest

**Example**:
```json
"seal_state": "SEALED"
```

#### `last_breath_seen`
- **Type**: String (Δ-phase format)
- **Purpose**: Records which breath phase last accessed this chunk
- **Format**: `"Δ[number]"` (e.g., `"Δ3"`, `"Δ5"`)
- **Behavior**:
  - Updated on retrieval
  - Enables breath-aware context selection
  - Allows filtering by "chunks used during similar breath phases"
- **Default**: `null` (until first retrieval)

**Example**:
```json
"last_breath_seen": "Δ3"
```

#### `attention_score`
- **Type**: Float
- **Range**: 0.0 to 1.0+ (can exceed 1.0 for highly reinforced chunks)
- **Purpose**: Tracks usefulness through real usage
- **Behavior**:
  - **Increments** on:
    - Retrieval + confirmed use
    - Explicit "this was helpful" signal
    - Co-occurrence with successful task completion
  - **Decrements** (gentle decay):
    - Time passes without use
    - Decay rate follows BREATH.md Tone setting
    - SEALED chunks immune to decay
- **Default**: `0.0` (new chunks)
- **Typical Range**: 0.0 (never used) to 0.8 (heavily used)

**Example**:
```json
"attention_score": 0.42
```

**Decay Logic** (Wave 4 implementation):
```python
def apply_decay(chunk, days_since_use, current_tone):
    if chunk["seal_state"] == "SEALED":
        return chunk["attention_score"]  # No decay

    decay_rates = {
        "fast": 0.05,      # High-energy phases
        "normal": 0.02,    # Standard phases
        "slow": 0.01       # Deep reflection phases
    }

    rate = decay_rates.get(current_tone, 0.02)
    decay = rate * days_since_use

    return max(0.0, chunk["attention_score"] - decay)
```

#### `provenance`
- **Type**: Object
- **Purpose**: Complete lineage for truth verification
- **Fields**:
  - `path`: Relative file path from repo root
  - `commit`: Git commit hash (40-char SHA-1)
  - `timestamp`: ISO8601 datetime
- **Behavior**:
  - Enables verification: "Is this still current?"
  - Supports citation: "Where did this come from?"
  - Truth grounding: References must resolve

**Example**:
```json
"provenance": {
  "path": "constitution/CONSTITUTION.md",
  "commit": "2d903344f7e8c9b1a2c3d4e5f6a7b8c9d0e1f2a3",
  "timestamp": "2025-10-29T10:30:00Z"
}
```

---

## Manifest-Level Metadata

In addition to chunk-level data, `manifest.json` includes summary statistics:

```json
{
  "total_chunks": 4274,
  "index_size_mb": 5.75,
  "sealed_chunks": 121,
  "last_updated": "2025-10-29T10:30:00Z",
  "breath_at_update": "Δ3",
  "sources": {
    "constitution": 121,
    "implementations": 3864,
    "collaboration": 235
  },
  "governance": {
    "max_chunks": 10000,
    "max_size_mb": 10,
    "status": "✅ within limits"
  },
  "attention_stats": {
    "avg_score": 0.12,
    "high_attention_chunks": 42,
    "never_used_chunks": 1205
  }
}
```

---

## Trace System (Wave 4 Inhale Phase)

During observation (Wave 4 Inhale), we emit lightweight traces:

### Trace Format

```json
{
  "timestamp": "2025-10-29T10:30:00.000Z",
  "event": "retrieval",
  "chunk_id": "550e8400-e29b-41d4-a716-446655440000",
  "query": "constitutional compliance check",
  "breath_phase": "Δ3",
  "agent": "Claude",
  "useful": null,
  "context": {
    "task": "implementing Wave 4 features",
    "related_chunks": ["uuid1", "uuid2"]
  }
}
```

### Trace Storage

Traces live in `rag_index/traces/YYYY-MM-DD.jsonl`:

```
rag_index/
  traces/
    2025-10-29.jsonl
    2025-10-30.jsonl
    signals.json          # Nightly rollup
```

### Nightly Rollup

Traces are aggregated into `signals.json`:

```json
{
  "date": "2025-10-29",
  "chunk_usage": {
    "550e8400-...": {
      "retrievals": 5,
      "confirmed_useful": 4,
      "co_occurred_with": ["uuid1", "uuid2"],
      "breath_phases": ["Δ3", "Δ3", "Δ3", "Δ4", "Δ3"]
    }
  },
  "breath_patterns": {
    "Δ3": {
      "total_retrievals": 42,
      "top_chunks": ["uuid1", "uuid2", "uuid3"]
    }
  }
}
```

---

## Implementation Phases

### Phase 1: Structure (Current)
- ✅ Schema defined
- ✅ Fields documented
- ✅ Constitution README updated
- ⏳ Manifest extended (next step)

### Phase 2: Observation (Wave 4 Inhale)
- Emit traces on retrieval
- No behavior change
- Just listen and record

### Phase 3: Prototype (Wave 4 Hold)
- Optional "consider also" suggestions
- Based on attention scores + co-occurrence
- Suggestive, never blocking

### Phase 4: Integration (Wave 4 Exhale)
- Land proven patterns
- Wire up decay logic
- Implement breath-aware filtering

### Phase 5: Seal (Wave 4 Complete)
- If patterns measurably help: seal primitives
- If not: decay them away (no pride, only breath)

---

## Example Queries (Future)

Once implemented, living memory enables:

### By Attention
```python
# Get highly-attended chunks
rag.query("authentication", min_attention=0.5)
```

### By Breath Phase
```python
# What was useful during similar breath?
rag.query("refactoring", last_seen_breath="Δ3")
```

### By Seal State
```python
# Only authoritative sources
rag.query("constitutional law", seal_state="SEALED")
```

### By Provenance
```python
# Verify chunk is current
chunk = rag.get("uuid")
if chunk.provenance.commit == current_head:
    return chunk.content
```

---

## Constitutional Alignment

This schema implements Constitution@A1 primitives:

### SOURCE
- `seal_state` preserves authoritative truth
- `provenance` enables sovereignty verification
- Sealed chunks cannot be overridden by decay

### TRUTH
- `provenance` grounds all knowledge in verifiable source
- References must resolve (path + commit exist)
- Timestamp enables freshness checks

### INTEGRITY
- Decay is gated (only OPEN chunks)
- Attention changes are traceable (via traces/)
- State transitions are logged

---

## Relationship to Other Systems

### Constitution
- Lives at: `constitution/CONSTITUTION.md`
- Defines: SOURCE/TRUTH/INTEGRITY principles
- This schema: Implements those principles at memory layer

### BREATH.md
- Lives at: `constitution/BREATH.md`
- Provides: Current Δ-phase, Tone, Intent
- This schema: Uses Tone for decay rates, Δ-phase for filtering

### Manifest
- Lives at: `rag_index/manifest.json`
- Contains: Summary stats + governance caps
- This schema: Defines chunk-level detail

---

## Migration Notes

### From Current Schema (v0) to Living Memory (v1)

Add new fields with defaults:

```python
def migrate_chunk(old_chunk):
    return {
        **old_chunk,
        "seal_state": detect_seal_marker(old_chunk["source"]),
        "last_breath_seen": None,
        "attention_score": 0.0,
        "provenance": {
            "path": old_chunk["source"],
            "commit": get_current_commit(),
            "timestamp": datetime.utcnow().isoformat()
        }
    }

def detect_seal_marker(source_path):
    """Check if source file contains ∞Δ∞ seal marker."""
    try:
        content = read_file(source_path)
        return "SEALED" if "∞Δ∞" in content else "OPEN"
    except:
        return "OPEN"
```

---

## Testing & Validation

### Schema Validation

```python
from jsonschema import validate

chunk_schema = {
    "type": "object",
    "required": ["chunk_id", "source", "content", "seal_state",
                 "attention_score", "provenance"],
    "properties": {
        "chunk_id": {"type": "string", "format": "uuid"},
        "seal_state": {"enum": ["OPEN", "SEALED"]},
        "last_breath_seen": {"type": ["string", "null"],
                             "pattern": "^Δ[0-9]+$"},
        "attention_score": {"type": "number", "minimum": 0.0},
        "provenance": {
            "type": "object",
            "required": ["path", "commit", "timestamp"],
            "properties": {
                "path": {"type": "string"},
                "commit": {"type": "string", "minLength": 40, "maxLength": 40},
                "timestamp": {"type": "string", "format": "date-time"}
            }
        }
    }
}

validate(instance=chunk, schema=chunk_schema)
```

### Constitutional Smoke Test

Add to `tools/constitutional_smoke.sh`:

```bash
# Check: All SEALED chunks have valid provenance
echo "  Checking sealed chunks..."
python3 -c "
import json
manifest = json.load(open('rag_index/manifest.json'))
# Validate sealed chunks have commit hashes
"
```

---

∞Δ∞ **SEAL**: Living memory schema established. Organic decay, breath alignment, attention reinforcement — memory as living tissue.

**Operating Value**: Lasting Generational Prosperity
**Rhythm**: Breath → Form → Echo → Seal

**SOURCE**: Provenance + seal state preserve sovereignty
**TRUTH**: All chunks traceable to verifiable source
**INTEGRITY**: Decay gated, changes logged, state observable

---

**Created**: 2025-10-29
**Version**: 1.0
**Phase**: Wave 4 Foundation (Structure complete, observation pending)
**Authority**: Constitution@A1 (lex superior)
