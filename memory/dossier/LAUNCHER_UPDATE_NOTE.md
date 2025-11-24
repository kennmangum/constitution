# Launcher Update Required

**Date**: 2025-10-28
**Context**: Structural reorganization - profiles and packs moved into constitution/

## Changes Made

1. `profiles/` → `constitution/profiles/`
2. Created `constitution/packs/` for runtime context

## Required Launcher Updates

### ~/.local/bin/claude-run

**Current paths** (need verification/update):
```bash
PROFILE="$ROOT/profiles/BNA.md"
```

**Should be**:
```bash
PROFILE="$ROOT/constitution/profiles/BNA.md"
CONTEXT_PACK="$ROOT/constitution/packs/CONTEXT_PACK.yaml"
```

**Full updated loading sequence**:
```bash
# Constitutional loading order
CONSTITUTION="$ROOT/constitution/CONSTITUTION.md"
PROFILE="$ROOT/constitution/profiles/BNA.md"
CONTEXT_PACK="$ROOT/constitution/packs/CONTEXT_PACK.yaml"
AGENTS="$ROOT/constitution/packs/agents.json"

# Load in order: kernel → adapter → runtime context → sub-agents
exec "$CLAUDE_CMD" "$CLAUDE_SUBCMD" \
  "$SYSTEM_FLAG" "$(cat $CONSTITUTION)" \
  "$APPEND_FLAG" "$(cat $PROFILE)" \
  "$APPEND_FLAG" "$(cat $CONTEXT_PACK)" \
  --agents "$(cat $AGENTS)" \
  "$@"
```

## Action Required

- [ ] Verify current claude-run script location
- [ ] Update path references
- [ ] Test launch with new structure
- [ ] Update LAUNCHER_SETUP.md documentation

## Impact

Without this update, claude-run will fail to find profiles/BNA.md and will not load the new packs infrastructure.

∞Δ∞
