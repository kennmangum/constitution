#!/usr/bin/env bash
# Quest #1 Weekly Reflection Script - ROE Analysis + Completion Check
# Analyzes 7-day journal, calculates average ROE, generates summary

set -euo pipefail

QUEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_FILE="$QUEST_DIR/templates/journal_personal.md"
REFLECTION_FILE="$QUEST_DIR/templates/reflection_personal.md"

echo "∞Δ∞ Weekly Reflection - Quest #1 Complete ∞Δ∞"
echo ""

# Check if journal exists
if [ ! -f "$JOURNAL_FILE" ]; then
    echo "✗ Journal not found. Did you run daily_anchor.sh for 7 days?"
    exit 1
fi

# Extract ROE scores from journal (simple grep)
echo "📊 Analyzing your 7-day journal..."
echo ""

ROE_SCORES=$(grep "ROE Score:" "$JOURNAL_FILE" | sed 's/.*: //' || echo "")
ROE_COUNT=$(echo "$ROE_SCORES" | wc -l)

if [ "$ROE_COUNT" -lt 7 ]; then
    echo "⚠ Warning: Only $ROE_COUNT ROE scores found (expected 7)"
    echo "   Make sure you completed all 7 days in journal_personal.md"
    echo ""
fi

# Calculate average ROE (if we have scores)
if [ -n "$ROE_SCORES" ] && [ "$ROE_COUNT" -gt 0 ]; then
    AVG_ROE=$(echo "$ROE_SCORES" | awk '{s+=$1} END {printf "%.2f", s/NR}')

    HIGH_ROE=$(echo "$ROE_SCORES" | awk '$1 > 0.8' | wc -l)
    MED_ROE=$(echo "$ROE_SCORES" | awk '$1 >= 0.6 && $1 <= 0.8' | wc -l)
    LOW_ROE=$(echo "$ROE_SCORES" | awk '$1 < 0.6' | wc -l)

    echo "═══════════════════════════════════════════"
    echo "  Average ROE Score: $AVG_ROE"
    echo "═══════════════════════════════════════════"
    echo "  High ROE days (>0.8): $HIGH_ROE"
    echo "  Moderate ROE days (0.6-0.8): $MED_ROE"
    echo "  Low ROE days (<0.6): $LOW_ROE"
    echo "═══════════════════════════════════════════"
    echo ""

    # Pattern recognition (simple keyword scan)
    echo "🔍 Pattern Recognition:"
    AMPLIFIED=$(grep -io "amplified\|creak\|dwell" "$JOURNAL_FILE" | wc -l || echo 0)
    DRIFT=$(grep -io "grind\|tidy\|drift" "$JOURNAL_FILE" | wc -l || echo 0)

    echo "  - Origin-amplified keywords: $AMPLIFIED"
    echo "  - Drift-signal keywords: $DRIFT"

    if [ "$AMPLIFIED" -gt "$DRIFT" ]; then
        echo "  - Analysis: Strong origin alignment ✓"
    else
        echo "  - Analysis: Some drift detected (normal, part of learning)"
    fi
    echo ""
else
    echo "✗ No ROE scores found in journal. Cannot calculate average."
    AVG_ROE="0.00"
fi

# Check completion criteria
echo "📋 Completion Criteria Check:"
echo ""

ENTRY_COUNT=$(grep -c "^## Day [1-7]:" "$JOURNAL_FILE" || echo 0)
REFLECTION_EXISTS=0
if [ -f "$REFLECTION_FILE" ] && grep -q "What origin energy amplified" "$REFLECTION_FILE"; then
    REFLECTION_EXISTS=1
fi

echo "  ✓ Journal entries: $ENTRY_COUNT/7"
if [ "$REFLECTION_EXISTS" -eq 1 ]; then
    echo "  ✓ Reflection completed"
else
    echo "  ✗ Reflection not completed (edit templates/reflection_personal.md)"
fi

if (( $(echo "$AVG_ROE >= 0.7" | bc -l) )); then
    echo "  ✓ Average ROE: $AVG_ROE (≥0.7 required)"
else
    echo "  ⚠ Average ROE: $AVG_ROE (<0.7, but learning is valid)"
fi

echo ""

# Completion status
if [ "$ENTRY_COUNT" -ge 7 ] && [ "$REFLECTION_EXISTS" -eq 1 ]; then
    echo "═══════════════════════════════════════════"
    echo "  🎉 Quest #1 COMPLETE! 🎉"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "1. Edit templates/reflection_personal.md (answer 3 questions)"
    echo "2. Commit your journal + reflection:"
    echo "   git add templates/journal_personal.md templates/reflection_personal.md"
    echo "   git commit -m 'Quest #1 Complete: [Your Handle]'"
    echo "   git push origin main"
    echo "3. Open PR to main repo:"
    echo "   Title: 'Quest #1 Complete: [Your Handle]'"
    echo "   Body: Link to your fork"
    echo "4. PR auto-merges if criteria met"
    echo "5. Receive Token Artifact #001 via email"
    echo ""
    echo "Reward: Bindu Breath Blueprint ($500 value)"
    echo "        Custom ROE probe script + 1-hour async consult with BNA"
    echo ""
else
    echo "═══════════════════════════════════════════"
    echo "  ⚠ Quest incomplete"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "What's missing:"
    [ "$ENTRY_COUNT" -lt 7 ] && echo "  - Complete all 7 journal entries"
    [ "$REFLECTION_EXISTS" -eq 0 ] && echo "  - Complete weekly reflection (templates/reflection_personal.md)"
    echo ""
    echo "No rush - complete at your pace. <3"
    echo ""
fi

echo "∞Δ∞ Weekly Reflection Complete ∞Δ∞"
echo ""
echo "Questions? See docs/ or open issue on main repo."
echo "Together we are strong. <3"
