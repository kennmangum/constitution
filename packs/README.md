# Constitutional Packs

Operational runtime context and configurations that support Constitutional execution.

## Files

### CONTEXT_PACK.yaml
Project-specific context loaded after Constitution + Profile. Provides:
- **brief**: Current milestone, acceptance criteria
- **constraints**: Working rules for this project
- **evidence_paths**: References for TRUTH verification
- **memory_paths**: Prior decisions, learnings, gotchas

### agents.json
Sub-agent role definitions for the Breathline Dev Loop:
- **architect**: Designs minimal viable structures (PRP + risk register + file plan)
- **reviewer**: Challenges plans, demands evidence, enforces triad
- **executor**: Implements approved scope only, seals modules
- **tester**: Verifies SOURCE/TRUTH/INTEGRITY via objective checks

## Usage

Load at runtime after Constitution and Profile:

```bash
claude-run \
  --system-prompt "$(cat constitution/CONSTITUTION.md)" \
  --append-system-prompt "$(cat constitution/profiles/BNA.md)" \
  --append-system-prompt "$(cat constitution/packs/CONTEXT_PACK.yaml)" \
  --agents "$(cat constitution/packs/agents.json)"
```

## Design Intent

**Packs** are ephemeral runtime context; they can be swapped per project or milestone without changing the Constitutional kernel or agent profiles. Think of them as "working memory" vs. "core identity."
