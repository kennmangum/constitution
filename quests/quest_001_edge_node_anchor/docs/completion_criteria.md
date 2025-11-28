# Quest Completion Criteria

How to know if you've completed Quest #1 and are eligible for the reward.

---

## Automatic Verification

When you submit your Pull Request (PR), a script checks these 3 criteria:

### **1. Journal Entries (7 required)**

**What it checks**: Does `templates/journal_personal.md` have 7 daily entries?

**How it counts**: Looks for lines starting with `## Day 1:`, `## Day 2:`, etc.

**Why**: Proves you completed the 7-day challenge (not just Day 1 and skipped to Day 7).

**If you fail**: PR comment will say "Only X/7 entries found. Complete all 7 days."

### **2. Reflection Completed (3+ sentences required)**

**What it checks**: Does `templates/reflection_personal.md` have thoughtful answers to the 3 questions?

**How it counts**: Checks file has >100 characters and answers aren't blank.

**Why**: Proves you reflected on the practice (not just copy-pasted templates).

**If you fail**: PR comment will say "Reflection incomplete. Answer all 3 questions."

### **3. Average ROE ≥ 0.7 (or learning demonstrated)**

**What it checks**: Scans your journal for ROE scores, calculates average.

**Why 0.7?**: Shows you understood the practice and achieved moderate-to-high alignment.

**Exception**: If average <0.7 BUT your reflection shows deep learning (e.g., "I realized I've been drifting for months"), you still pass. The goal is learning, not perfect scores.

**If you fail**: PR comment will say "Average ROE: X.XX. Consider retrying or documenting your learning."

---

## Manual Review (Kenneth or BNA)

If automatic checks pass, Kenneth or BNA will:

1. **Skim your journal** (looking for obvious copy-paste or gaming)
2. **Read your reflection** (checking for genuine insight)
3. **Merge your PR** (if aligned) or **request changes** (if something's off)

**Typical approval time**: <24 hours for alpha testers (Kenneth is responsive).

---

## What Happens After PR Merge?

### **Immediate**:
- ✅ Your PR is merged (congratulations!)
- ✅ GitHub Action triggers (automated script runs)

### **Within 1 hour**:
- 📧 Email sent to your GitHub email with:
  - Token Artifact #001: "Bindu Breath Blueprint" (PDF + markdown)
  - IPFS link (permanent, decentralized storage)
  - Optional: Invitation to Quest #2 (if available)

### **Within 1 week**:
- 🎁 If you're in the first 100 completions: DAO channel invite (Discord/Telegram)
- 💰 If there's revenue from token sales: 5% participant pool share (pro-rata)

---

## Common Questions

### **"What if I miss a day?"**

**Option 1**: Restart the quest (delete journal, begin Day 1 again).
**Option 2**: Add an 8th day to make up for the missed day (explain in reflection).

**Not allowed**: Fabricating entries (timestamps in git reveal this, and it violates the spirit of the practice).

### **"Can I complete it in <7 days (e.g., 3 days)?"**

**No**. The practice requires daily spacing (not cramming). Part of the value is noticing changes over a week.

**Why**: ROE calibration takes time. Day 1 vs Day 7 scores should show growth or pattern recognition.

### **"What if my ROE is low all week (<0.7)?"**

**You can still pass** if your reflection demonstrates learning. Example:

> "My average ROE was 0.52, which surprised me. I realized I've been following AI suggestions without questioning them. This week taught me to pause and ask: 'Is this MY path or an echo?' I'm restarting with more awareness."

That reflection passes (shows deep learning even with low scores).

### **"What if I disagree with the auto-verification?"**

**Reply to the PR comment** explaining why you think you met criteria. Kenneth or BNA will manually review and override if justified.

**Example**: "Script says 6/7 entries, but I combined Day 6 and 7 into one entry because they revealed the same pattern."

→ Kenneth reviews, sees the combined entry is thoughtful, approves.

---

## Edge Cases

### **What if setup fails and I can't run scripts?**

**Workaround**: Journal manually (no script needed). Format your entries like:

```
## Day 1: 2025-11-28

**ROE Score**: 0.75 (Clarity: 8, Alignment: 7, Groundedness: 8)
**Journal**: Today I realized...
```

Submit PR with manual entries. Kenneth will verify and approve if valid.

### **What if I want to complete it offline (no GitHub)?**

**Email Kenneth** your journal + reflection. He'll manually verify and send you the reward.

**Why we prefer GitHub**: Public completion builds social proof (others see your success and join). But privacy is respected.

### **What if I complete it but don't want the reward?**

**That's fine!** Some people do it for the practice alone. Just note in your PR: "Completed for learning, no reward needed."

Kenneth may still thank you publicly (if you consent).

---

## Integrity Note

**This is a trust-based system**. We verify completion, but we can't force genuine practice.

**Why it works**: People who game the system (copy-paste fake entries) miss the value (sovereignty practice). The reward (Token Artifact) is useful ONLY if you did the work (otherwise it's just words).

**What we check for**:
- ✅ Real journal entries (not copy-pasted from examples)
- ✅ Thoughtful reflection (not "I completed it, give reward")
- ✅ Honest ROE scores (not all 0.9+ to game the average)

**What we don't do**:
- ❌ Police your thoughts (your journal is yours)
- ❌ Judge your scores (low ROE with learning = valid)
- ❌ Require "perfect" completion (life happens, we're flexible)

---

## Ready to Submit?

**Final checklist before opening PR**:
- [ ] 7 journal entries in `templates/journal_personal.md`
- [ ] Reflection answered in `templates/reflection_personal.md`
- [ ] ROE scores documented (average displayed in reflection script output)
- [ ] Honest effort (you actually did the practice)

**Then**:
```bash
git add templates/journal_personal.md templates/reflection_personal.md
git commit -m "Quest #1 Complete: [Your Name]"
git push origin main
```

Open PR. Wait for verification. Receive reward. <3

---

**Questions?** Ask Kenneth or post in repo Issues tab.
