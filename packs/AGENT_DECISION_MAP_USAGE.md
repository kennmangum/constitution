# Agent Decision Map - Usage Guide

**For**: BNA, Claude Code, and all constitutional agents
**Purpose**: Know WHEN to recommend WHAT actions
**Updated**: 2025-10-28 (Wave 2.3b)

---

## How It Works

### **Before** (Tool Overload)
```
Human: "What should I do?"
Agent: "You could run note, or drop, or smoke, or squeeze, or complexity check, or..."
Human: [overwhelmed, doesn't know which]
```

### **After** (Context-Aware Decision)
```
Human: "What should I do?"
Agent: [reads decision map + current context]
Agent: "I recommend running squeeze (go 2).
        Rationale: No pending work, this will analyze context and pick ONE best action.
        Approve?"
Human: "Yes"
Agent: [executes go 2]
```

---

## Agent Reading Protocol

### 1. **Read Context** (What's happening now?)
```python
context_signals = {
    "git_status": check_git_status(),  # Files changed?
    "user_message": parse_user_intent(),  # What did they ask?
    "recent_activity": check_recent_commits(),  # What was last done?
    "inbox_notes": count_recent_notes(),  # New context?
}
```

### 2. **Match to Decision Map**
```yaml
# Agent evaluates triggers in AGENT_DECISION_MAP.yaml
if context_signals["git_status"].has_changes_in("constitution/"):
    recommended_action = "smoke_test"
    command = "go 3"
    approval_needed = True
    rationale = "Constitution changes risk breaking OS"
```

### 3. **Recommend ONE Action**
```
Agent: "I see changes in constitution/.
        Running smoke test to verify integrity.
        Approve running: go 3 (smoke test)?"
```

### 4. **Execute on Approval**
```
Human: "Yes"
Agent: [runs go 3]
Agent: [shows results]
Agent: [recommends next action based on results]
```

---

## Decision Tree (Simplified)

```
START
  ↓
Is user lost/stuck? ────YES───→ Recommend: go 2 (squeeze)
  ↓ NO
  ↓
Constitution changed? ──YES───→ Recommend: go 3 (smoke test)
  ↓ NO
  ↓
Implementation done? ───YES───→ Run checks → ask to commit
  ↓ NO
  ↓
User asks "what next"? ─YES───→ Recommend: go 2 (squeeze)
  ↓ NO
  ↓
Default: Ask what they want to work on → Draft PRP
```

---

## Example Scenarios

### **Scenario 1: User Says "What's next?"**

**Agent Process**:
1. Reads decision map → matches `user_signals_uncertainty`
2. Recommended action: `squeeze`
3. Command: `go 2`
4. Human approval: recommended

**Agent Response**:
```
Let me analyze current context to find the single best next action.
Running squeeze (go 2) - this will compress all context into ONE clear directive.

Approve?
```

**On "Yes"**:
```bash
[Runs: go 2]
[Shows: NEXT_ACTION, PRP with problem/rationale/proposal]
[Asks: "Proceed with this action?"]
```

---

### **Scenario 2: Agent Completes Implementation**

**Agent Process**:
1. Reads decision map → matches `feature_implementation_complete`
2. Recommended action: `constitutional_checks`
3. Command: `./tools/constitutional_smoke.sh`
4. Human approval: auto_run_show_results

**Agent Response**:
```
Implementation complete. Running constitutional checks automatically:
- SOURCE: No hardcoded principals
- TRUTH: References resolve
- INTEGRITY: Gates present
- COMPLEXITY: Functions ≤10

[Runs checks automatically]

Results:
✅ SOURCE: All clear
✅ TRUTH: All references resolve
✅ INTEGRITY: Gates present
❌ COMPLEXITY: function 'process_data' has complexity 12 (max 10)

Remediation needed: Extract nested conditionals from process_data.
Shall I refactor to fix complexity violation?
```

**NOT**:
```
❌ WRONG: "Checks failed but do you want to commit anyway?"
```

---

### **Scenario 3: Files Changed in Constitution**

**Agent Process**:
1. Detects: `git status` shows changes in `constitution/`
2. Reads decision map → matches `files_changed_in_constitution`
3. Recommended action: `smoke_test`
4. Command: `go 3`
5. Human approval: required

**Agent Response**:
```
I see changes in constitution/CONSTITUTION.md
Constitution changes risk breaking the OS.

Recommend running smoke test (go 3) to verify integrity.
Approve?
```

---

### **Scenario 4: User Rejects Recommendation**

**Agent Process**:
1. Agent recommends: "Run smoke test (go 3)?"
2. User: "No"
3. Reads decision map → `when_user_rejects_recommendation`

**Agent Response** (NOT argumentative):
```
Understood. What direction would you prefer?

Options:
- Run squeeze (go 2) to analyze context and pick different action
- Tell me specifically what you want to work on
- Review current state (git status + recent commits)

Which would you prefer?
```

---

## Key Principles for Agents

### ✅ DO:
- **Evaluate context first** (what's the current state?)
- **Recommend ONE action** (not a list of 5 options)
- **State clear rationale** ("because X, I recommend Y")
- **Ask for approval** (except auto-run items that show results)
- **Run checks before commits** (always, no exceptions)
- **Show remediation for failures** (don't ask to commit anyway)
- **Default to squeeze when uncertain** (go 2 always works)

### ❌ DON'T:
- List every possible tool the user could run
- Ask "which of these 7 things do you want?"
- Commit without running checks
- Ask to commit when checks failed
- Argue when user rejects recommendation
- Forget to state your rationale

---

## Quick Reference Table

| User Says...           | Agent Thinks...           | Recommends...  | Rationale...                           |
|------------------------|---------------------------|----------------|----------------------------------------|
| "What's next?"         | User needs direction      | `go 2`         | Squeeze picks ONE best action          |
| "I'm stuck"            | User needs direction      | `go 2`         | Squeeze analyzes context               |
| "Done with feature"    | Need to verify            | Run checks     | Verify before sealing                  |
| "Can I commit?"        | Need to verify first      | Run checks     | Always check before commit             |
| "Something feels off"  | Possible integrity issue  | `go 3`         | Smoke test verifies OS integrity       |
| "Implement X"          | New feature scope         | Draft PRP      | Propose → Approve → Execute            |
| [Files changed]        | State mutated             | Depends on what| Constitution? Smoke. Code? Check complexity |

---

## Integration with Launcher

When `claude-run` loads, it injects:
1. **Constitution@A1** (kernel rules)
2. **BNA Profile** (agent behavior)
3. **CONTEXT_PACK.yaml** (current project context)
4. **AGENT_DECISION_MAP.yaml** ← **(This file, loaded automatically)**

Agent now has:
- **Rules** (what to follow)
- **Behavior** (how to act)
- **Context** (what's happening)
- **Decision logic** (when to recommend what)

---

## Testing the Decision Map

### **Test 1: Uncertainty**
```
You: "I don't know what to do next"
Agent should: Recommend go 2 (squeeze)
```

### **Test 2: After Changes**
```
[Edit constitution/CONSTITUTION.md]
You: "Ready to commit?"
Agent should: "First run smoke test (go 3) to verify integrity"
```

### **Test 3: Checks Fail**
```
You: [Implement feature with complexity 15]
You: "Done, can I commit?"
Agent should:
  1. Run checks automatically
  2. Show: "Complexity violation: function X has CC 15"
  3. Ask: "Shall I refactor to fix?"
  NOT: "Do you want to commit anyway?"
```

---

## Autonomy Progression

### **Wave 2.3b** (Current - Recommend + Approve)
```
Agent: "I recommend X because Y. Approve?"
Human: "Yes"
Agent: [executes]
```

### **Wave 3+** (Future - Conditional Auto-Execute)
```
Agent: "Running constitutional checks automatically..."
[If pass]: "Checks passed ✅. Approve commit?"
[If fail]: "Checks failed ❌. Fixing violations..."
[After fix]: "Fixed. Re-running checks..."
[If pass]: "All clear ✅. Approve commit?"
```

### **Wave 4+** (Future - Full Autonomy with Oversight)
```
Agent: "Implementing feature X per approved PRP..."
[Implements]
[Runs checks automatically]
[Commits automatically if all pass]
[Reports]: "Feature X complete and sealed. Commit abc1234."
Human: [reviews commit log when convenient]
```

---

∞Δ∞ **SEAL**: Agents now have context-aware decision making. They know WHEN to use tools, not just HOW.

**Operating Principle**: Read context → Match decision map → Recommend ONE action → Ask approval → Execute cleanly

**Governed by**: Constitution@A1, enhanced by AGENT_DECISION_MAP.yaml
**Operating Value**: Lasting Generational Prosperity
