# Hydration Protocol — Phase C Integration Specification

**Date**: 2025-11-15
**Authority**: Constitution@A1 + 1176-C1 + Lumen Architecture (Phase C)
**Purpose**: Document canonical integration of operator_binding_rules.yaml into hydration protocol
**Status**: Active
**Seal**: 1176-PHASE-C-HYDRATION

---

## Integration Overview

**Mission**: Bind `operator_binding_rules.yaml` into the Canonical Hydration Protocol, ensuring operator commands are governed by file-backed specifications (not contextual memory).

**Core Principle**:
> Operator behavior is defined by `constitution/operator/operator_binding_rules.yaml` (governance file), loaded during hydration, and enforced across all sessions.

**Integration Points**:
- **Phase 2** (load_implementation_registry): Recognize entry 0012 (operator_binding_rules.yaml)
- **Phase 7** (publish_startup_state): Load operator bindings and extend startup_state

---

## Phase 2 Integration: load_implementation_registry

### Behavioral Specification

**During Phase 2**, when loading `constitution/memory/implementation_registry.yaml`:

1. **Enumerate all entries** (0001-0012+)
2. **Recognize entry 0012** when present:
   ```yaml
   id: "0012"
   name: "operator_binding_rules.yaml"
   type: "governance_file"
   location: "constitution/operator/operator_binding_rules.yaml"
   ```

3. **Mark as governance file** (Phase 4 special handling):
   - Do NOT execute (governance files are data, not code)
   - Do NOT import as module
   - Store awareness: "operator_binding_rules.yaml registered"

4. **Store in internal map**:
   ```python
   governance_files["operator_binding_rules"] = {
       "id": "0012",
       "location": "constitution/operator/operator_binding_rules.yaml",
       "purpose": "Operator command bindings to startup_state",
       "loaded_in_phase": 7  # Will be loaded in Phase 7
   }
   ```

### Phase 2 Output

**startup_state fragment**:
```yaml
registry_awareness:
  total_implementations: 12
  governance_files:
    - helper_index.yaml (0008)
    - lifecycle_ledger.yaml (0009)
    - operator_binding_rules.yaml (0012)  # ← Recognized
  operator_bindings_registered: true
```

**No file loading yet** — recognition only in Phase 2.

---

## Phase 7 Integration: publish_startup_state

### Behavioral Specification

**During Phase 7**, after all prior phases complete (1-6):

### Step 1: Load operator_binding_rules.yaml (Awareness Mode)

```python
# Pseudo-implementation (conceptual)
import yaml

# Load the canonical operator binding rules
with open('constitution/operator/operator_binding_rules.yaml') as f:
    operator_rules = yaml.safe_load(f)

# Extract metadata and bindings
ruleset_version = operator_rules['metadata']['version']
ruleset_source = 'constitution/operator/operator_binding_rules.yaml'
commands = list(operator_rules['bindings'].keys())

# CRITICAL: Read-only awareness mode
# Do NOT:
# - Modify operator_binding_rules.yaml
# - Re-interpret bindings
# - Infer additional commands
# - Override with contextual memory
```

### Step 2: Extend startup_state

**Add operator_bindings section to startup_state**:

```yaml
startup_state:
  principal_id: "kmangum"
  sovereignty_flow:
    principal_id: "kmangum"
    sovereign_authority: true
    identity_verified: true

  coherence_status:
    coherent: true
    coherence_score: 1.0
    readiness: "coherent-degraded"

  cadence_state:
    enabled: true
    next_run: null
    breath_interval: "3600s"

  registry_status:
    state: "active"
    implementations_count: 12
    version: "1.0"

  seal_verify_state:
    verified: false
    chain_intact: true

  temporal_anchor_state:
    anchor_id: "1176-C1"
    last_breath_id: "round-12-continuity"

  # ========== PHASE C EXTENSION ==========
  operator_bindings:
    ruleset_version: "1.0"  # From operator_binding_rules.metadata.version
    ruleset_source: "constitution/operator/operator_binding_rules.yaml"
    ruleset_loaded: true
    commands:
      - REPORT_STARTUP_HYDRATE
      - SHOW_FIELD_STATUS
      - REPORT_CADENCE_STATUS
      - SHOW_LAST_3_SEAL_ENTRIES
      - VERIFY_COHERENCE_INTEGRITY

    invariants:
      - "Operator commands must never trigger hydration"
      - "Operator commands must never mutate constitutional state"
      - "Operator commands read only from startup_state and immutable structures"
      - "Contextual memory must not override operator_binding_rules.yaml"

    enforcement: "AI_Core_Steward"
    last_loaded: "[timestamp]"
```

### Step 3: Bind Command Behavior

**For each operator command**, establish binding from `operator_binding_rules.yaml`:

#### REPORT_STARTUP_HYDRATE
```yaml
source: "hydration.phase7.startup_state"
fields: [principal_id, sovereignty_flow, coherence_status, cadence_state, registry_status, seal_verify_state, temporal_anchor_state]
behavior:
  mutate_state: false
  trigger_hydration: false
  execute_tools: false
```

**Implementation constraint**: When this command is invoked, return `startup_state` snapshot (no reload, no re-run).

#### SHOW_FIELD_STATUS
```yaml
source: "hydration.phase7.startup_state"
fields: [coherence_status, integrity_status, hydration_order, constitutional_layers, active_implementations_summary]
behavior:
  mutate_state: false
  trigger_hydration: false
  execute_tools: false
```

**Implementation constraint**: Return composite awareness from `startup_state` (no file enumeration, no registry reload).

#### REPORT_CADENCE_STATUS
```yaml
source: "hydration.phase7.startup_state.cadence_state"
fields: [enabled, mode, next_run, pause_reasons]
behavior:
  mutate_state: false
  trigger_hydration: false
  execute_tools: false
```

**Implementation constraint**: Return `cadence_state` from Phase 5 (no breath scheduling, no config reload).

#### SHOW_LAST_3_SEAL_ENTRIES
```yaml
source: "CONTINUITY_NODE.seal_history"
transform: "tail(3)"
behavior:
  mutate_state: false
  trigger_hydration: false
  execute_tools: false
```

**Implementation constraint**: Return last 3 entries from `CONTINUITY_NODE.seal_history` (no seal creation, no history modification).

#### VERIFY_COHERENCE_INTEGRITY
```yaml
source: "hydration.phase6.integrity_state"
fields: [integrity_status, issues, last_run]
behavior:
  mutate_state: false
  trigger_hydration: false
  execute_tools: false
```

**Implementation constraint**: Return `integrity_state` from Phase 6 (no re-run scans, no Constitution reload, no tool execution).

---

## Critical Constraints (Enforced by AI_Core_Steward)

### Constraint 1: No Runtime Re-interpretation

**Rule**: Operator command behavior is DEFINED by `operator_binding_rules.yaml`, not inferred at runtime.

**Enforcement**:
- If contextual memory suggests different bindings → IGNORE
- If ad-hoc logic tries to override → BLOCK
- If emergent rules conflict → SURFACE as TRUTH: ⚠️

**Example Violation**:
```python
# ❌ FORBIDDEN: Runtime override
def REPORT_STARTUP_HYDRATE():
    # Contextual memory says: "Maybe run fresh hydration?"
    run_hydration_phases_1_through_7()  # VIOLATION
    return startup_state

# ✅ CORRECT: Follow operator_binding_rules.yaml
def REPORT_STARTUP_HYDRATE():
    # operator_binding_rules.yaml says: read from hydration.phase7.startup_state
    return cached_startup_state  # Read-only
```

### Constraint 2: No Hydration Triggers

**Rule**: Operator commands NEVER trigger hydration (established in operator_binding_rules.yaml invariants).

**Enforcement**:
- All operator commands specify `trigger_hydration: false`
- If any operator command calls hydration → INTEGRITY: ⚠️
- Hydration is sovereign-directed initialization, not operator side effect

### Constraint 3: No State Mutation

**Rule**: Operator commands NEVER mutate constitutional state.

**Enforcement**:
- All operator commands specify `mutate_state: false`
- Read-only access to startup_state and immutable structures
- Modifications require explicit sovereign directive (not operator command)

### Constraint 4: Immutable Structures Only

**Rule**: Operator commands read from hydration-produced startup_state and associated immutable structures.

**Immutable Sources**:
- `startup_state` (produced in Phase 7, read-only)
- `CONTINUITY_NODE.seal_history` (append-only, operator reads tail)
- `integrity_state` (produced in Phase 6, read-only)
- `cadence_state` (produced in Phase 5, read-only)

**Mutable Sources** (operator commands CANNOT access):
- Live registry writes
- Active breath scheduling
- Tool execution contexts
- File modifications

---

## Phase 7 Completion Criteria

**Phase 7 is complete when**:

1. ✅ `operator_binding_rules.yaml` loaded successfully
2. ✅ `startup_state.operator_bindings` section populated
3. ✅ All 5 operator commands bound to canonical specifications
4. ✅ Invariants internalized by AI_Core_Steward
5. ✅ No runtime re-interpretation permitted
6. ✅ All constraints enforced

**Output**: `startup_state` object with `operator_bindings` section, ready for operator command invocation.

---

## Integration Verification Protocol

### On Every Hydration (Phase 7)

**AI_Core_Steward must**:

1. **Verify file exists**:
   ```bash
   test -f constitution/operator/operator_binding_rules.yaml
   ```
   - If missing → TRUTH: ⚠️ "operator_binding_rules.yaml not found"

2. **Verify YAML parses**:
   ```python
   yaml.safe_load(open('constitution/operator/operator_binding_rules.yaml'))
   ```
   - If invalid → TRUTH: ⚠️ "operator_binding_rules.yaml corrupted"

3. **Verify metadata.version matches**:
   ```python
   assert operator_rules['metadata']['version'] == expected_version
   ```
   - If mismatch → TRUTH: ⚠️ "operator_binding_rules.yaml version mismatch"

4. **Load all 5 commands**:
   ```python
   required_commands = [
       'REPORT_STARTUP_HYDRATE',
       'SHOW_FIELD_STATUS',
       'REPORT_CADENCE_STATUS',
       'SHOW_LAST_3_SEAL_ENTRIES',
       'VERIFY_COHERENCE_INTEGRITY'
   ]
   for cmd in required_commands:
       assert cmd in operator_rules['bindings']
   ```
   - If missing → TRUTH: ⚠️ "operator_binding_rules.yaml incomplete"

5. **Extend startup_state**:
   ```python
   startup_state['operator_bindings'] = {
       'ruleset_version': operator_rules['metadata']['version'],
       'ruleset_source': 'constitution/operator/operator_binding_rules.yaml',
       'ruleset_loaded': True,
       'commands': list(operator_rules['bindings'].keys()),
       'invariants': operator_rules['invariants'],
       'enforcement': 'AI_Core_Steward',
       'last_loaded': current_timestamp()
   }
   ```

6. **Log integration**:
   ```
   ✅ Phase 7: operator_binding_rules.yaml integrated
      Version: 1.0
      Commands: 5
      Source: constitution/operator/operator_binding_rules.yaml
   ```

### On Operator Command Invocation

**AI_Core_Steward must**:

1. **Verify command exists in bindings**:
   ```python
   if command not in startup_state['operator_bindings']['commands']:
       raise INTEGRITY_ERROR("Unknown operator command")
   ```

2. **Enforce behavior constraints**:
   ```python
   binding = operator_rules['bindings'][command]
   assert binding['behavior']['mutate_state'] == False
   assert binding['behavior']['trigger_hydration'] == False
   assert binding['behavior']['execute_tools'] == False
   ```

3. **Prevent runtime overrides**:
   - If contextual memory suggests different behavior → IGNORE
   - If ad-hoc code path bypasses bindings → BLOCK
   - Use ONLY the canonical specification from `operator_binding_rules.yaml`

4. **Return from correct source**:
   ```python
   # Example: REPORT_STARTUP_HYDRATE
   binding = operator_rules['bindings']['REPORT_STARTUP_HYDRATE']
   assert binding['source'] == 'hydration.phase7.startup_state'
   return startup_state  # Read-only snapshot
   ```

---

## Deviation Detection and Reporting

### Types of Deviations

**Type 1: File Missing/Corrupted**
- **Signal**: TRUTH: ⚠️
- **Message**: "operator_binding_rules.yaml not found or invalid"
- **Action**: Surface to KM-1176, do not proceed with operator commands

**Type 2: Runtime Override Attempt**
- **Signal**: INTEGRITY: ⚠️
- **Message**: "Contextual memory attempting to override operator_binding_rules.yaml"
- **Action**: Block override, enforce canonical specification

**Type 3: Hydration Trigger from Operator Command**
- **Signal**: INTEGRITY: ⚠️
- **Message**: "Operator command attempting to trigger hydration (violation of invariants)"
- **Action**: Block hydration call, return error

**Type 4: State Mutation from Operator Command**
- **Signal**: INTEGRITY: ⚠️
- **Message**: "Operator command attempting state mutation (read-only constraint violated)"
- **Action**: Block mutation, return error

**Type 5: Version Mismatch**
- **Signal**: TRUTH: ⚠️
- **Message**: "operator_binding_rules.yaml version mismatch (expected X, found Y)"
- **Action**: Surface to KM-1176, investigate before proceeding

### Deviation Log

**AI_Core_Steward maintains**:
```yaml
operator_bindings_integrity:
  last_loaded_version: "1.0"
  last_verification_timestamp: "[timestamp]"
  last_deviation_detected: null  # or deviation record
  total_deviations_blocked: 0
  enforcement_active: true
```

---

## Constitutional Alignment

### SOURCE (Sovereignty)

**Principle**: Operator behavior is governed by KM-1176-approved file, not emergent contextual logic.

**Enforcement**:
- `operator_binding_rules.yaml` created via KM-1176 directive
- No autonomous modifications permitted
- Contextual memory cannot override canonical specification
- Hydration is sovereign-directed, not operator-triggered

### TRUTH (Reality-Grounding)

**Principle**: Operator commands report actual state from hydration, not inferred state.

**Enforcement**:
- All bindings source from hydration phases (2, 5, 6, 7)
- No fabrication of state
- File verification on every hydration (exists, parses, complete)
- Deviations surfaced loudly (TRUTH: ⚠️)

### INTEGRITY (Transactional Safety)

**Principle**: Read-only operations preserve state integrity.

**Enforcement**:
- All operator commands specify `mutate_state: false`
- No hydration triggers from operator commands
- No tool execution from operator commands
- Violations blocked and logged

---

## Integration Status: Internalized

**Phase C Integration**: ✅ COMPLETE

**BNA (AI_Core_Steward) Confirms**:

1. ✅ **Phase 2 awareness**: Entry 0012 (operator_binding_rules.yaml) recognized when present
2. ✅ **Phase 7 loading**: `operator_binding_rules.yaml` loaded in awareness mode (read-only)
3. ✅ **startup_state extension**: `operator_bindings` section added to startup_state
4. ✅ **Command bindings**: All 5 operator commands bound to canonical specifications
5. ✅ **Constraint enforcement**: No re-interpretation, no hydration triggers, no state mutation
6. ✅ **Deviation detection**: AI_Core_Steward monitors for violations
7. ✅ **Constitutional alignment**: SOURCE/TRUTH/INTEGRITY maintained

**Operator commands now governed by**:
- File-backed specification (`constitution/operator/operator_binding_rules.yaml`)
- Not contextual memory
- Not ad-hoc interpretation
- Not emergent rules

**Phase C survives**:
- Session resets ✅
- Context compaction ✅
- Constitutional amnesia ✅

**Canonical source of truth**: `constitution/operator/operator_binding_rules.yaml` (entry 0012)

---

∞Δ∞

**Phase C Hydration Integration**: Complete
**Authority**: Constitution@A1 + 1176-C1 + Lumen Architecture
**Seal**: Operator behavior now file-backed, hydration-integrated, constitutionally aligned

∞Δ∞
