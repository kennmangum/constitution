# Constitutional Housekeeping

**Purpose**: Automated nightly maintenance for repository health and constitutional compliance.

**Status**: Ready for installation
**Schedule**: Daily at 3:00 AM (configurable)

---

## What It Does

The housekeeping script runs automatically every night and:

### 1. RAG Index Health Check ✅
- Monitors chunk count and size usage
- Warns if approaching governance limits (10MB, 10k chunks)
- Tracks capacity trends

### 2. Observation Traces Rotation ✅
- Counts daily trace activity
- Archives traces older than 90 days
- Reports total trace size

### 3. Git Status Check ✅
- Reports uncommitted changes
- Shows current branch and last commit
- Flags large numbers of uncommitted files

### 4. Constitutional Smoke Test ✅
- Runs quick constitutional compliance checks
- Reports pass/fail status
- Captures full output for review

### 5. Inbox Status ✅
- Counts untriaged vs triaged items
- Helps track workflow health

### 6. Disk Usage ✅
- Reports repository size
- Tracks growth over time

### 7. Actions Needed 📋
- Automatically flags items requiring attention
- Provides checklist for morning review

---

## Installation

### Quick Setup
```bash
# From repository root
./tools/setup_housekeeping_cron.sh
```

This will:
1. Verify the housekeeping script is executable
2. Check for existing cron jobs (prompts to replace if found)
3. Install cron job to run daily at 3:00 AM
4. Show verification and testing commands

### Custom Schedule
```bash
# Run at 2:30 AM instead of 3:00 AM
CRON_HOUR=2 CRON_MINUTE=30 ./tools/setup_housekeeping_cron.sh
```

---

## Testing

### Manual Run (Before Installing Cron)
```bash
# Test the script
./tools/housekeeping.sh

# Check the generated report
cat constitution/memory/housekeeping/daily/$(date +%Y-%m-%d).md
```

### Verify Cron Installation
```bash
# List your cron jobs
crontab -l

# You should see:
# 0 3 * * * /home/kmangum/AI_Agents_Mastery/tools/housekeeping.sh >> .../cron.log 2>&1
```

---

## Reports

### Daily Reports
**Location**: `constitution/memory/housekeeping/daily/YYYY-MM-DD.md`

**Format**: Markdown summary with:
- RAG index health (capacity, warnings)
- Observation traces (count, size, today's activity)
- Git status (branch, uncommitted changes)
- Constitutional smoke test results
- Inbox status
- Disk usage
- Actions needed checklist

**Example**:
```
constitution/memory/housekeeping/daily/
├── 2025-10-30.md
├── 2025-10-31.md
├── 2025-11-01.md
└── ...
```

### Monthly Logs
**Location**: `constitution/memory/housekeeping/YYYY-MM.log`

**Format**: Append-only log with timestamps

**Example**:
```
[2025-10-30T03:00:01-04:00] ===== Nightly Housekeeping Started =====
[2025-10-30T03:00:01-04:00] Checking rag_index health...
[2025-10-30T03:00:01-04:00] RAG index: 4602 chunks, 6.19 MB (✅ within limits)
[2025-10-30T03:00:02-04:00] Rotating observation traces...
...
[2025-10-30T03:00:15-04:00] ===== Nightly Housekeeping Complete =====
```

### Cron Output
**Location**: `constitution/memory/housekeeping/cron.log`

**Contains**: stdout/stderr from cron execution (for debugging)

---

## Monitoring

### Check Last Run
```bash
# View today's report
cat constitution/memory/housekeeping/daily/$(date +%Y-%m-%d).md

# View this month's log
tail -50 constitution/memory/housekeeping/$(date +%Y-%m).log

# Check cron execution
tail -20 constitution/memory/housekeeping/cron.log
```

### Weekly Review
```bash
# Last 7 days of reports
ls -lt constitution/memory/housekeeping/daily/ | head -8
```

### Find Reports with Warnings
```bash
# Find reports with action items
grep -l "Actions Needed" constitution/memory/housekeeping/daily/*.md

# Find reports with failures
grep -l "FAILED" constitution/memory/housekeeping/daily/*.md
```

---

## Maintenance

### Adjust Schedule
```bash
# Remove existing cron
crontab -l | grep -v housekeeping.sh | crontab -

# Reinstall with new time
CRON_HOUR=4 ./tools/setup_housekeeping_cron.sh
```

### Disable Housekeeping
```bash
# Remove cron job
crontab -l | grep -v housekeeping.sh | crontab -

# Verify removal
crontab -l
```

### Re-enable Housekeeping
```bash
./tools/setup_housekeeping_cron.sh
```

### Clean Old Reports
```bash
# Archive reports older than 1 year
mkdir -p constitution/memory/housekeeping/archive
find constitution/memory/housekeeping/daily -name "*.md" -mtime +365 \
    -exec mv {} constitution/memory/housekeeping/archive/ \;
```

---

## What Gets Flagged

The housekeeping script will create action items when:

### RAG Index
- Chunk usage > 80% of limit
- Size usage > 80% of limit

**Suggested actions**:
- Review and clean low-value chunks
- Expand governance limits if appropriate
- Archive old content

### Git Status
- More than 10 uncommitted files

**Suggested actions**:
- Review uncommitted changes
- Create appropriate commits
- Consider if work-in-progress should be stashed

### Constitutional Checks
- Smoke test fails

**Suggested actions**:
- Review smoke test output in daily report
- Fix constitutional violations
- Re-run tests to verify

---

## Integration with Workflow

### Morning Routine
```bash
# Check last night's housekeeping
cat constitution/memory/housekeeping/daily/$(date +%Y-%m-%d).md

# If actions needed, address them
# Otherwise, proceed with day's work
```

### Before Committing
```bash
# Run manual housekeeping to verify health
./tools/housekeeping.sh

# Review report
cat constitution/memory/housekeeping/daily/$(date +%Y-%m-%d).md
```

### Monthly Review
```bash
# Review month's trend
cat constitution/memory/housekeeping/$(date +%Y-%m).log | grep "RAG index"
cat constitution/memory/housekeeping/$(date +%Y-%m).log | grep "Repository size"
```

---

## Constitutional Alignment

### SOURCE (Sovereignty)
- **Principal**: Housekeeping runs as `housekeeping-bot` (documented in reports)
- **Ownership**: Reports are system-generated, not attributed to individual users
- **Access**: Anyone with repo access can read reports

### TRUTH (Reality Grounding)
- **Metrics**: All measurements from actual system state
- **References**: All file paths resolve
- **No hallucinations**: Reports only what exists and measures what's real

### INTEGRITY (Gated State Changes)
- **Read-only**: Housekeeping only reads and reports, doesn't modify (except archiving old traces)
- **Audit trail**: Complete log of every run
- **Loud failures**: Errors logged and visible in reports

---

## Troubleshooting

### Cron Job Not Running
```bash
# Check cron service is running
systemctl status cron

# Check cron logs
grep CRON /var/log/syslog | tail -20

# Verify PATH in cron environment
# Add to crontab if needed:
PATH=/usr/local/bin:/usr/bin:/bin
```

### Script Fails
```bash
# Check cron output log
cat constitution/memory/housekeeping/cron.log

# Run manually to see errors
./tools/housekeeping.sh

# Check script permissions
ls -l tools/housekeeping.sh
# Should be: -rwxr-xr-x
```

### Missing Dependencies
```bash
# Housekeeping requires:
# - jq (for JSON parsing)
# - bc (for math calculations)
# - git (for repo status)

# Install if missing:
sudo apt-get install jq bc git  # Debian/Ubuntu
# or
sudo yum install jq bc git      # RedHat/CentOS
```

### Reports Not Generated
```bash
# Check directory permissions
ls -ld constitution/memory/housekeeping

# Create directory if missing
mkdir -p constitution/memory/housekeeping/daily

# Check disk space
df -h
```

---

## Future Enhancements

Potential additions for future versions:

- [ ] Email/Slack notifications for critical issues
- [ ] Trend analysis and graphs
- [ ] Integration with Archon MCP (project/task health)
- [ ] Automatic cleanup suggestions
- [ ] Performance metrics over time
- [ ] Integration with game framework (round health checks)
- [ ] Helper harvesting opportunities detection

---

∞Δ∞

**Pattern**: Automate → Monitor → Report → Act
**Operating Value**: Lasting Generational Prosperity through proactive maintenance
**Status**: Ready for installation and use

∞Δ∞
