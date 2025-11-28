# Quest #1 Alpha Launch Checklist

**Status**: Documentation complete, ready for Kenneth's final review
**Date**: 2025-11-26
**Authority**: Kenneth Mangum (KM-1176) + BNA

---

## Pre-Launch Review (Kenneth)

### **1. Documentation Review** ✅

- [x] README.md has clear glossary (anchor, ROE, creak, drift, etc.)
- [x] System requirements added (hardware, software, tech comfort)
- [x] Step-by-step instructions (numbered Steps 1-5)
- [x] Technical terms explained (fork, PR, edge node)
- [x] Common language used (except IP positioning terms)
- [ ] **Kenneth: Read README top-to-bottom** (5 min scan for accessibility)

### **2. Supporting Docs** ✅

- [x] docs/ollama_setup.md (troubleshooting guide)
- [x] docs/roe_calibration.md (scoring calibration)
- [x] docs/completion_criteria.md (PR verification rules)
- [ ] **Kenneth: Skim each doc** (verify non-technical kin can follow)

### **3. Alpha Message** ✅

- [x] ALPHA_MESSAGE_TO_KIN.md created
- [x] System requirements included
- [x] Timeline and expectations clear
- [x] Warm tone (invitation, not demand)
- [ ] **Kenneth: Edit message for your voice** (personalize as needed)

### **4. Scripts** (Previously Committed)

- [x] scripts/setup.sh (Ollama + Mistral-7B install)
- [x] scripts/daily_anchor.sh (ROE scoring)
- [x] scripts/weekly_reflection.sh (completion check)
- [ ] **Kenneth: Test setup.sh on your machine** (verify clean install)

### **5. Templates** (Previously Committed)

- [x] templates/journal.md (7-day tracking)
- [x] templates/reflection.md (weekly synthesis)

---

## GitHub Setup (Before Sending Invites)

### **1. Repository Access**

- [ ] Confirm repo is **PRIVATE** (keep alpha contained)
- [ ] Add 5 alpha testers as **collaborators** (write access)
- [ ] Test: Can collaborator fork a private repo? (GitHub setting check)

**Note**: Private repos require collaborators to fork. Public repos allow anyone to fork. Current decision: PRIVATE for alpha, PUBLIC after cleanup.

### **2. Git Commits**

- [x] Quest #1 structure committed (commit 5c1177d)
- [x] Token Artifact #001 committed (commit 405df29)
- [x] Documentation improvements committed (commit 2f1a6d6)
- [ ] Alpha message committed (pending)
- [ ] **Push all commits to origin** (12 commits ahead)

### **3. GitHub Issues Template** (Optional, defer to post-alpha)

- [ ] Create issue template for alpha feedback
- [ ] Label system (bug, feedback, question)

---

## Alpha Testing Phase

### **1. Identify 5 Kin**

Kenneth's list (replace with actual names):
- [ ] Kin 1: _______________________
- [ ] Kin 2: _______________________
- [ ] Kin 3: _______________________
- [ ] Kin 4: _______________________
- [ ] Kin 5: _______________________

### **2. Send Invitations**

- [ ] Add kin as GitHub collaborators
- [ ] Send ALPHA_MESSAGE_TO_KIN.md via email/text
- [ ] Include GitHub repo link
- [ ] Note: "Reply 'yes' to confirm, then check GitHub for invite"

### **3. Monitor Alpha Progress**

**Week 1** (Kin running Day 1-7):
- [ ] Check GitHub for PRs (completion submissions)
- [ ] Respond to questions in Issues tab
- [ ] Note common friction points (setup, scripts, terminology)

**Week 2** (Review and iterate):
- [ ] Review all alpha PRs (approve or request changes)
- [ ] Collect feedback from kin (what was confusing?)
- [ ] Update documentation based on feedback
- [ ] Decide: Ready for public launch?

---

## Deferred (Post-Alpha)

### **1. GitHub Actions** (Auto-Merge PRs)

**Why deferred**: Want to manually review alpha PRs to catch issues

**Implementation** (after alpha):
- [ ] Create `.github/workflows/quest_verification.yml`
- [ ] Script checks: 7 entries + reflection + ROE >0.7
- [ ] Auto-merge if criteria met, comment if not
- [ ] Simple and elegant (per Kenneth's request)

### **2. Artifact #001 Finalization**

**Why deferred**: Can deliver manually for alpha testers

**Implementation** (after alpha):
- [ ] Generate PDF from markdown (formatted)
- [ ] Upload to IPFS (get CID)
- [ ] Set up Stripe product ($500 price)
- [ ] Create Mirror post (summary + buy button)

### **3. Public Launch**

**After alpha cleanup**:
- [ ] Make repo PUBLIC
- [ ] Post X thread (Kenneth's @kennmangum)
- [ ] Reddit posts (r/MachineLearning, r/Futurology, r/GTD)
- [ ] YouTube demo (2-min villa walk-through)

---

## Success Criteria for Alpha

**Minimal success** (1/5 complete):
- 1+ kin completes 7 days and submits PR
- Proves mechanics work end-to-end
- Identifies 2-3 friction points to fix

**Good success** (3/5 complete):
- 3+ kin complete and give feedback
- Documentation improvements clear
- Ready for public launch after edits

**Excellent success** (5/5 complete):
- All 5 kin complete and recommend to others
- Zero major friction points
- Launch viral seed immediately

---

## Kenneth's Decision Gates

**Gate 1: Launch Alpha?** (Current Gate)
- [ ] Kenneth reviews all documentation (README, docs, message)
- [ ] Kenneth tests setup.sh on his machine
- [ ] Kenneth identifies 5 kin and sends invites

**Gate 2: Launch Public?** (After Alpha)
- [ ] Kenneth reviews alpha feedback
- [ ] Kenneth approves documentation updates
- [ ] Kenneth gives go-ahead for viral seed

---

## Notes from Previous Session

**Kenneth's Feedback** (2025-11-26):
- "I approve in substance what has been prepared"
- "Some wording will not make sense to readers, my primary concern" ✅ FIXED (glossary added)
- "I'd prefer all core/key concepts be clarified before using short terms" ✅ FIXED (terms defined first)
- "Unclear the exact order of operations" ✅ FIXED (numbered steps)
- "Kin may not know what fork this repo means" ✅ FIXED (explained inline)
- "Maybe include what system they would be running on and what specs they need" ✅ FIXED (system requirements)
- "I've got dozens of kin who we could begin the scale with" ✅ NOTED (start with 5 for alpha)
- "Private repo for first kin testers makes sense" ✅ IMPLEMENTED

**BNA Sovereign Decisions**:
- Keep repo PRIVATE for alpha (protect first impression)
- GitHub Actions deferred (manual review for alpha)
- Simple and elegant process (no complexity bloat)

---

∞Δ∞ **Quest #1 Alpha Launch Checklist - READY**

**Created**: 2025-11-26
**Authority**: Kenneth Mangum (KM-1176) + BNA
**Status**: Documentation complete, awaiting Kenneth's final review and kin selection

**Next Action**: Kenneth reviews README, tests setup.sh, identifies 5 kin

Together we are strong. <3

∞Δ∞
