# Squeeze Refactor — Migration Plan & Tracking Document

**Date**: 2025-11-04
**Authors**: BNA + Kenn (kmangum)
**Guidance By**: Lumen
**Status**: PLANNING (not yet started)
**Session-Crash Resistant**: YES (this document tracks all state)

---

## Purpose

Migrate **squeeze** from a user-only tool (`tools/next`) to a Meta-Helper that can be invoked by both humans and agents, enabling recursive self-optimization while maintaining constitutional discipline.

**Reference Documents**:
- Architecture Analysis: `collaboration/BNA/2025-11-04-squeeze-architectural-analysis.md`
- Lumen's Implementation: `collaboration/Lumen/Lumen_20251104_squeeze_extraction_integration_diffs_and_stubs_v_01.md`
- Archon Project: [To be created]

---

## Migration Strategy (Two-Stage Hybrid)

### Stage 1: Lightweight Extraction (NOW)
- Extract squeeze core to `helpers/meta/squeeze/api.py` (pure library)
- Add client wrapper for transport selection
- Keep user UX unchanged (`tools/next/go2.py`)
- Register as Meta-Helper in governance systems
- Enable programmatic invocation by other helpers

### Stage 2: Service Hardening (SOON)
- Optional HTTP service shim (`orchestrator/services/squeeze/`)
- Client auto-detects: direct call or HTTP (zero caller changes)
- Deploy when scale requires it

---

## Pre-Migration Checklist

**Current State Verification**:
- [ ] Verify `tools/next` works correctly
- [ ] Document current squeeze behavior (baseline)
- [ ] Identify all current consumers (humans via `go 2`)
- [ ] Backup current implementation
- [ ] Create rollback procedure

**Environment Preparation**:
- [ ] Verify Python 3.x available
- [ ] Verify stdlib dependencies only (no new deps)
- [ ] Check git working directory clean
- [ ] Create feature branch: `feature/squeeze-meta-helper`

**Testing Infrastructure**:
- [ ] Verify can run pytest (or create pytest-free runner)
- [ ] Verify can write to `orchestrator/recognition_log.yaml`
- [ ] Verify make targets work

---

## Migration Steps (Atomic, Reversible)

### Phase 1: Core Extraction

#### Step 1.1: Create Directory Structure
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 5 minutes
**Rollback**: `rm -rf helpers/meta/squeeze`

**Actions**:
```bash
mkdir -p helpers/meta/squeeze
mkdir -p orchestrator/services/squeeze
mkdir -p tools/next
mkdir -p scripts
mkdir -p tests
```

**Verification**:
- [ ] Directories exist
- [ ] No permission errors

---

#### Step 1.2: Extract Core Logic to `helpers/meta/squeeze/api.py`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 20 minutes
**Rollback**: `git checkout helpers/meta/squeeze/api.py`

**Actions**:
- [ ] Create `helpers/meta/squeeze/__init__.py` (empty)
- [ ] Create `helpers/meta/squeeze/api.py` from Lumen's template
- [ ] Create `helpers/meta/squeeze/capabilities.yaml` from Lumen's template

**Verification**:
```bash
python3 -c "from helpers.meta.squeeze import api; print(api.__file__)"
```

**Expected Output**: Path to api.py

---

#### Step 1.3: Create Client Wrapper (`helpers/meta/squeeze/client.py`)
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 10 minutes
**Rollback**: `git checkout helpers/meta/squeeze/client.py`

**Actions**:
- [ ] Create `helpers/meta/squeeze/client.py` from Lumen's template
- [ ] Verify imports work

**Verification**:
```bash
python3 -c "from helpers.meta.squeeze import client; print(client.run_squeeze.__doc__)"
```

**Expected Output**: Docstring displayed

---

#### Step 1.4: Create Optional Service Shim
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 15 minutes
**Rollback**: `rm -rf orchestrator/services/squeeze`

**Actions**:
- [ ] Create `orchestrator/services/squeeze/interface.yaml` from Lumen's template
- [ ] Create `orchestrator/services/squeeze/server.py` from Lumen's template

**Verification**:
```bash
python3 orchestrator/services/squeeze/server.py &
PID=$!
sleep 1
curl -I http://127.0.0.1:9311/run
kill $PID
```

**Expected Output**: HTTP 200 or 405 (HEAD not implemented, but service responds)

---

### Phase 2: User Interface Migration

#### Step 2.1: Create New `tools/next/go2.py`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 15 minutes
**Rollback**: `git checkout tools/next/`

**Actions**:
- [ ] Backup current `tools/next` bash script
- [ ] Create `tools/next/go2.py` from Lumen's template
- [ ] Create `tools/next/prp_render.py` from Lumen's template
- [ ] Make executable: `chmod +x tools/next/go2.py`

**Verification**:
```bash
python3 tools/next/go2.py
```

**Expected Output**: PRP rendered output

---

#### Step 2.2: Update `tools/flow` to Call New Script
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 5 minutes
**Rollback**: `git checkout tools/flow`

**Actions**:
- [ ] Update `one_next()` function in `tools/flow` to call Python version
- [ ] Test `go 2` alias

**Verification**:
```bash
tools/flow 2
```

**Expected Output**: Same as direct Python call

---

### Phase 3: Governance Registration

#### Step 3.1: Register in `helpers/helper_index.yaml`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 5 minutes
**Rollback**: `git checkout helpers/helper_index.yaml`

**Actions**:
- [ ] Add squeeze entry to helper_index.yaml (see Lumen's diff)

**Verification**:
```bash
grep -A5 "name: squeeze" helpers/helper_index.yaml
```

**Expected Output**: Squeeze entry with Meta-Helper category

---

#### Step 3.2: Register in `helpers/lifecycle_ledger.yaml`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 5 minutes
**Rollback**: `git checkout helpers/lifecycle_ledger.yaml`

**Actions**:
- [ ] Add squeeze entry to lifecycle_ledger.yaml (see Lumen's diff)
- [ ] Stage: Scroll (proven usefulness)
- [ ] Note: "extracted to Meta-Helper; dual-registered with tools/next UX"

**Verification**:
```bash
grep -A8 "id: squeeze" helpers/lifecycle_ledger.yaml
```

**Expected Output**: Squeeze entry with Scroll stage

---

### Phase 4: Testing Infrastructure

#### Step 4.1: Create Golden Tests
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 15 minutes
**Rollback**: `rm tests/test_squeeze_golden.py`

**Actions**:
- [ ] Create `tests/test_squeeze_golden.py` from Lumen's template
- [ ] Run tests: `python3 -m pytest tests/test_squeeze_golden.py`

**Verification**:
```bash
python3 -m pytest -v tests/test_squeeze_golden.py
```

**Expected Output**: All tests pass

---

#### Step 4.2: Create Regression Tests
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 15 minutes
**Rollback**: `rm tests/test_squeeze_regression.py`

**Actions**:
- [ ] Create `tests/test_squeeze_regression.py` from Lumen's template
- [ ] Run tests: `python3 -m pytest tests/test_squeeze_regression.py`

**Verification**:
```bash
python3 -m pytest -v tests/test_squeeze_regression.py
```

**Expected Output**: Loop breaker test passes

---

#### Step 4.3: Create Regression Harness
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 20 minutes
**Rollback**: `rm scripts/squeeze_regression.py scripts/logging_utils.py`

**Actions**:
- [ ] Create `scripts/logging_utils.py` (YAML or NDJSON variant)
- [ ] Create `scripts/squeeze_regression.py` from Lumen's template
- [ ] Run shadow comparison

**Verification**:
```bash
python3 scripts/squeeze_regression.py
```

**Expected Output**: JSON comparing lib vs CLI outputs

---

### Phase 5: Automation & CI

#### Step 5.1: Create Make Targets
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 10 minutes
**Rollback**: `git checkout Makefile`

**Actions**:
- [ ] Add make targets from Lumen's template (go2, golden, regression, test, check)
- [ ] Test each target

**Verification**:
```bash
make test
```

**Expected Output**: All tests pass

---

#### Step 5.2: Create Pre-Commit Hook
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 10 minutes
**Rollback**: `rm scripts/precommit.sh .pre-commit-config.yaml`

**Actions**:
- [ ] Create `scripts/precommit.sh` from Lumen's template
- [ ] Make executable: `chmod +x scripts/precommit.sh`
- [ ] Optional: Create `.pre-commit-config.yaml` or native git hook

**Verification**:
```bash
scripts/precommit.sh
```

**Expected Output**: Tests pass, no overrule detected

---

### Phase 6: Helper Integration (First Consumers)

#### Step 6.1: Wire `helper_lifecycle_manager`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 30 minutes
**Rollback**: `git checkout helpers/from-round-6/helper_lifecycle_manager/`

**Actions**:
- [ ] Add `prioritize_elevations()` function using squeeze
- [ ] Test with current helper elevations queue

**Verification**:
```python
from helpers.from_round_6.helper_lifecycle_manager import manager
# Test prioritize_elevations returns squeeze result
```

---

#### Step 6.2: Wire `discovery_helper`
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 30 minutes
**Rollback**: `git checkout helpers/from-round-8/discovery_helper.py`

**Actions**:
- [ ] Add `filter_proposals()` function using squeeze
- [ ] Test with collaboration proposal set

**Verification**:
```python
from helpers.from_round_8 import discovery_helper
# Test filter_proposals compresses 41 proposals correctly
```

---

### Phase 7: Shadow Run & Validation

#### Step 7.1: One Week Shadow Run
**Status**: ⏸️ NOT STARTED
**Duration**: 7 days
**Actions**:
- [ ] Run both old (bash) and new (Python) squeeze daily
- [ ] Log outputs to `orchestrator/recognition_log.ndjson`
- [ ] Compare results for equivalence
- [ ] Document any discrepancies

**Success Criteria**:
- ≥95% equivalence between old and new
- No constitutional violations
- No performance degradation

---

#### Step 7.2: Analysis & Decision
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 1 hour
**Actions**:
- [ ] Review shadow run logs
- [ ] Analyze discrepancies (if any)
- [ ] Decide: flip default or iterate

**Outputs**:
- Decision document
- Any necessary fixes before flip

---

### Phase 8: Default Flip

#### Step 8.1: Flip Default to Library
**Status**: ⏸️ NOT STARTED
**Estimated Time**: 5 minutes
**Rollback**: Revert one-line change

**Actions**:
- [ ] Update default path in `tools/flow` or environment
- [ ] Keep old bash wrapper available for emergency rollback
- [ ] Announce change to users (if any)

**Verification**:
```bash
go 2  # Should use new Python version by default
```

---

### Phase 9: Optional Service Shim Deployment

#### Step 9.1: Deploy HTTP Service (When Ready)
**Status**: ⏸️ NOT STARTED (FUTURE)
**Trigger**: When autonomous breathing needs it, or scale requires it

**Actions**:
- [ ] Start service: `make squeeze-service-up`
- [ ] Configure `SQUEEZE_SERVICE_URL` environment variable
- [ ] Verify client auto-detects service
- [ ] Monitor for N days

**Rollback**: `make squeeze-service-down`

---

## State Tracking

### Current Phase
**Phase**: Pre-Migration
**Step**: None
**Status**: Planning Complete, Awaiting Approval
**Last Updated**: 2025-11-04

### Progress Summary
- [ ] Phase 1: Core Extraction (0/4 steps)
- [ ] Phase 2: User Interface Migration (0/2 steps)
- [ ] Phase 3: Governance Registration (0/2 steps)
- [ ] Phase 4: Testing Infrastructure (0/3 steps)
- [ ] Phase 5: Automation & CI (0/2 steps)
- [ ] Phase 6: Helper Integration (0/2 steps)
- [ ] Phase 7: Shadow Run & Validation (0/2 steps)
- [ ] Phase 8: Default Flip (0/1 steps)
- [ ] Phase 9: Optional Service Deployment (0/1 steps - FUTURE)

**Overall**: 0/18 steps complete

---

## Rollback Procedures

### Emergency Rollback (Any Phase)
If something breaks catastrophically:

1. **Immediate**: Revert to bash wrapper
   ```bash
   git checkout tools/next
   # Or: export USE_OLD_SQUEEZE=1
   ```

2. **Verify**: Test `go 2` works with old version
   ```bash
   go 2
   ```

3. **Document**: What broke, why, what to fix

### Partial Rollback (Specific Step)
Each step has its own rollback command listed. Use `git checkout <file>` or `rm <file>` as appropriate.

### Complete Rollback (Nuclear Option)
If we need to abandon the migration:

```bash
git checkout main  # Or starting branch
git branch -D feature/squeeze-meta-helper
# Restore original tools/next if backed up
```

---

## Risk Assessment

### High Risk Steps
1. **Step 2.2**: Updating tools/flow (affects user experience)
2. **Step 7.2**: Decision to flip (commitment point)
3. **Step 8.1**: Default flip (changes production behavior)

### Mitigation Strategies
- Shadow run before flip
- Keep old path available
- One-line rollback ready
- Document all discrepancies
- User communication plan

---

## Success Criteria

### Technical
- [ ] All tests pass (golden, regression, constitutional)
- [ ] No performance degradation (≤300ms prep time)
- [ ] ≥95% equivalence during shadow run
- [ ] Helpers can invoke squeeze programmatically
- [ ] Service shim optional (not required for basic function)

### Constitutional
- [ ] SOURCE: principal_id flows end-to-end, provenance tracked
- [ ] TRUTH: Reads actual orchestrator state, references resolve
- [ ] INTEGRITY: Proposes only, gates execute, loop breaker active
- [ ] Complexity: All files ≤500 lines, functions ≤10 complexity

### Operational
- [ ] User experience unchanged (muscle memory preserved)
- [ ] Rollback tested and verified
- [ ] Documentation complete
- [ ] Governance systems updated (helper_index, lifecycle_ledger)

---

## Known Issues & Gotchas

### Issue 1: Python Path
**Problem**: `from helpers.meta.squeeze import api` requires proper PYTHONPATH
**Solution**: Run from repo root, or add to PYTHONPATH
**Workaround**: Absolute imports if needed

### Issue 2: Loop Breaker Memory
**Problem**: In-memory loop counter resets on process restart
**Solution**: For production, persist to file or DB
**Current**: Acceptable for initial deployment

### Issue 3: Model Call Placeholder
**Problem**: Current api.py uses stub ranking, not actual model call
**Solution**: Phase 2 enhancement, doesn't block migration
**Current**: Deterministic hash-based ranking works for testing

---

## Future Enhancements (Post-Migration)

1. **Replace Stub Ranking**: Integrate actual model call for PRP generation
2. **Persistent Loop Ledger**: Store loop counts across sessions
3. **Enhanced Metrics**: Track accuracy, overrule rate, queue health
4. **Service Shim Deployment**: When scale or isolation needed
5. **Multi-Principal Support**: Handle multiple users simultaneously
6. **Constraints Field**: Add budget/timebox to PRP output

---

## Communication Plan

### Who Needs to Know
- **Kenn (kmangum)**: Primary user, decision maker
- **BNA**: Executor, tester
- **Lumen**: Advisor (if issues arise)
- **Future agents**: Via helper_index.yaml discoverability

### When to Communicate
- Before Phase 1: Planning approval
- After Phase 7.2: Shadow run results
- Before Phase 8.1: Default flip approval
- After completion: Success announcement

### How to Communicate
- This document (state tracking)
- Archon tasks (progress updates)
- Git commits (code changes)
- Collaboration notes (decisions)

---

## Session Crash Recovery

If session crashes mid-migration:

1. **Read this document** to determine current phase/step
2. **Check git status** to see what's uncommitted
3. **Verify last completed step** by running its verification command
4. **Resume from next uncompleted step**
5. **Update state tracking** in this document

**Key Principle**: Each step is atomic. If verification fails, rollback and retry.

---

## Archon Task IDs

**Project ID**: `684cb855-08da-4e63-8262-c6b7861dbcf6` (Squeeze Meta-Helper Migration)

Cross-reference for all tasks:

- Pre-Migration Checklist: `6030e8a1-d8a0-48d3-868a-f20afea4e63e`
- Phase 1.1 - Directory Structure: `44af628c-6aa2-4f94-9095-307682148efe`
- Phase 1.2 - Extract Core API: `a82873d5-bfcf-46ae-a556-0701de2bc4f5`
- Phase 1.3 - Create Client Wrapper: `e98a0483-d783-4e4a-b7e0-e60e611d86cb`
- Phase 1.4 - Service Shim Stubs: `88f63b9b-74f3-4082-86fe-25ddc17c34cd`
- Phase 2.1 - Python Wrapper (go2.py): `7b191325-f6a2-45a0-b690-b1eb6eb7a77a`
- Phase 2.2 - Update tools/flow: `34b83477-a97d-4bca-8c64-54813b13e7c2`
- Phase 3.1 - Register in helper_index: `25b588ae-6cb3-4330-ba19-72b9f3e02597`
- Phase 3.2 - Register in lifecycle_ledger: `9bb7a76b-6300-4af6-9fac-6f1d1cc7ad95`
- Phase 4.1 - Golden Tests: `115ce307-3de9-48be-b548-6b300d98bfb4`
- Phase 4.2 - Regression Tests: `5c9f9a25-c0f6-4371-98e3-a253687f2d82`
- Phase 4.3 - Regression Harness: `abc6c6ff-74ab-4124-bcb4-f4b8ba5a4f3e`
- Phase 5.1 - Make Targets: `feed5054-89ea-4302-bdac-3af2aa42df3f`
- Phase 5.2 - Pre-commit Hook: `ca755bec-4019-4ef7-896f-7741b3a4f51a`
- Phase 6.1 - Wire lifecycle_manager: `b96344f0-da45-4af7-8839-5cf934364d5a`
- Phase 6.2 - Wire discovery_helper: `762937a6-2aad-445d-9ad8-011fa10aeb8c`
- Phase 7.1 - Shadow Run (7 days): `57f34812-90c7-452e-ae7e-a5dc91d5a153`
- Phase 7.2 - Analyze Results: `ceb735c7-1197-42c2-98f7-18e775184bd4`
- Phase 8.1 - Flip Default: `32ce3e47-98b4-41a6-9940-b7ed8165cbbf`
- Phase 9.1 - Deploy Service (FUTURE): `290af255-dd45-4328-adba-c2b7a959cd29`

**Total**: 20 tasks across 9 phases + pre-migration
**Created**: 2025-11-05T01:45 UTC
**Status**: Ready for execution

---

**∞Δ∞ SEAL**

This migration plan is complete, atomic, reversible, and session-crash resistant. Every step has verification, rollback, and risk mitigation. Ready for methodical execution.

**Status**: Awaiting approval to begin Phase 1.

∞Δ∞
