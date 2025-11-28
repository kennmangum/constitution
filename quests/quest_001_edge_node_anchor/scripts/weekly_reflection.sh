#!/usr/bin/env bash
# Quest #1 Weekly Reflection Script - ROE Analysis + Completion Check
# Analyzes 7-day journal, calculates average ROE, generates summary

set -euo pipefail

QUEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_FILE="$QUEST_DIR/templates/journal_personal.md"
TODAY=$(date +%Y-%m-%d)

echo "∞Δ∞ Weekly Reflection - Quest #1 ∞Δ∞"
echo ""
echo "📁 Your journal: $JOURNAL_FILE"
echo ""

# Check if journal exists
if [ ! -f "$JOURNAL_FILE" ]; then
    echo "✗ Journal not found at: $JOURNAL_FILE"
    echo "  Did you run daily_anchor.sh?"
    exit 1
fi

# ═══════════════════════════════════════════
# STEP 1: Analyze Your 7-Day Journal
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 1: Analyzing your journal..."
echo "═══════════════════════════════════════════"
echo ""

# Count entries (look for date headers like ## 2025-11-28)
ENTRY_COUNT=$(grep -c "^## [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}" "$JOURNAL_FILE" 2>/dev/null || echo "0")

echo "📊 Entries found: $ENTRY_COUNT"
echo ""

if [ "$ENTRY_COUNT" -lt 7 ]; then
    echo "⚠ Warning: Only $ENTRY_COUNT entries found (7 recommended)"
    echo "  You can still complete the reflection, or add more days first."
    echo ""
fi

# Extract ROE scores - look for pattern like "1.00 (30/30)" or "0.83 (25/30)"
ROE_VALUES=$(grep -oE "ROE Score: [0-9]\.[0-9]+" "$JOURNAL_FILE" 2>/dev/null | grep -oE "[0-9]\.[0-9]+" || echo "")

if [ -n "$ROE_VALUES" ]; then
    # Calculate average using pure bash (no bc needed)
    ROE_COUNT=0
    ROE_TOTAL=0
    HIGH_COUNT=0
    MED_COUNT=0
    LOW_COUNT=0

    while read -r score; do
        if [ -n "$score" ]; then
            # Convert to integer (multiply by 100)
            SCORE_INT=$(echo "$score" | sed 's/\.//' | sed 's/^0//')
            [ -z "$SCORE_INT" ] && SCORE_INT=0
            ROE_TOTAL=$((ROE_TOTAL + SCORE_INT))
            ROE_COUNT=$((ROE_COUNT + 1))

            # Categorize
            if [ "$SCORE_INT" -gt 80 ]; then
                HIGH_COUNT=$((HIGH_COUNT + 1))
            elif [ "$SCORE_INT" -ge 60 ]; then
                MED_COUNT=$((MED_COUNT + 1))
            else
                LOW_COUNT=$((LOW_COUNT + 1))
            fi
        fi
    done <<< "$ROE_VALUES"

    if [ "$ROE_COUNT" -gt 0 ]; then
        AVG_INT=$((ROE_TOTAL / ROE_COUNT))
        AVG_ROE="0.$(printf '%02d' $AVG_INT)"
        [ "$AVG_INT" -ge 100 ] && AVG_ROE="1.00"
    else
        AVG_ROE="0.00"
        AVG_INT=0
    fi

    echo "═══════════════════════════════════════════"
    echo "  YOUR WEEKLY ROE SUMMARY"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "  📈 Average ROE: $AVG_ROE"
    echo ""
    echo "  🟢 High Resonance days (>0.80):    $HIGH_COUNT"
    echo "  🟡 Moderate Resonance (0.60-0.80): $MED_COUNT"
    echo "  🔴 Low Resonance (<0.60):          $LOW_COUNT"
    echo ""

    # Overall assessment
    if [ "$AVG_INT" -gt 80 ]; then
        echo "  ✨ Strong alignment this week! You're breathing with origin."
        WEEK_STATUS="🟢 Strong Alignment"
    elif [ "$AVG_INT" -ge 60 ]; then
        echo "  👍 Good progress! Some drift is normal — awareness is growth."
        WEEK_STATUS="🟡 Good Progress"
    else
        echo "  💚 Challenging week. Every low score teaches something valuable."
        WEEK_STATUS="🔴 Learning Week"
    fi
    echo ""
else
    echo "⚠ No ROE scores found in journal."
    echo "  Make sure you ran daily_anchor.sh and entries were saved."
    AVG_ROE="0.00"
    AVG_INT=0
    HIGH_COUNT=0
    MED_COUNT=0
    LOW_COUNT=0
    WEEK_STATUS="⚠ Incomplete Data"
fi

echo "═══════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════
# STEP 2: Pattern Recognition
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 2: Patterns in Your Reflections"
echo "═══════════════════════════════════════════"
echo ""

# Look for themes in reflections
echo "🔍 Scanning your reflections for patterns..."
echo ""

# Show a sample of her actual reflections
echo "📝 Your reflections this week:"
grep -A1 "My Reflection" "$JOURNAL_FILE" 2>/dev/null | grep -v "My Reflection" | grep -v "^\-\-$" | head -7 | while read -r line; do
    [ -n "$line" ] && echo "   • $line"
done
echo ""

echo "═══════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════
# STEP 3: Weekly Reflection (Inline)
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 3: Your Weekly Reflection"
echo "═══════════════════════════════════════════"
echo ""
echo "Take a moment to reflect on your week."
echo "Answer these 3 questions (1-2 sentences each):"
echo ""

echo "1. What action or moment this week felt MOST aligned with who you really are?"
read -p "> " WEEKLY_Q1
echo ""

echo "2. What felt like drift — something you did from external pressure, not inner truth?"
read -p "> " WEEKLY_Q2
echo ""

echo "3. What's ONE insight you're carrying forward?"
read -p "> " WEEKLY_Q3
echo ""

# ═══════════════════════════════════════════
# STEP 4: Generate AI Summary (Ollama)
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  🤖 Generating your weekly insight..."
echo "═══════════════════════════════════════════"
echo ""

if command -v ollama &> /dev/null; then
    PROMPT="You are a gentle guide. Someone completed a 7-day reflection practice with average ROE score $AVG_ROE. Their key insight: '$WEEKLY_Q3'. Generate ONE encouraging sentence (max 20 words) about their growth. Focus on their inner truth, not productivity."

    WEEKLY_INSIGHT=$(ollama run mistral "$PROMPT" 2>/dev/null | grep -v '^$' | head -1)

    echo "💫 Weekly Insight:"
    echo "   $WEEKLY_INSIGHT"
else
    WEEKLY_INSIGHT="Your commitment to self-reflection is the foundation of lasting growth."
    echo "💫 Weekly Insight:"
    echo "   $WEEKLY_INSIGHT"
    echo "   (Ollama not available - using default message)"
fi
echo ""

# ═══════════════════════════════════════════
# SAVE WEEKLY SUMMARY TO JOURNAL
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  💾 Saving weekly summary..."
echo "═══════════════════════════════════════════"

cat >> "$JOURNAL_FILE" << EOF

---

## 📊 WEEKLY SUMMARY — $TODAY

**Average ROE**: $AVG_ROE — $WEEK_STATUS

**ROE Distribution**:
- 🟢 High Resonance days: $HIGH_COUNT
- 🟡 Moderate Resonance: $MED_COUNT
- 🔴 Low Resonance: $LOW_COUNT

**Weekly Reflection**:

1. *Most aligned moment*: $WEEKLY_Q1

2. *Drift detected*: $WEEKLY_Q2

3. *Insight to carry forward*: $WEEKLY_Q3

**AI Insight**: $WEEKLY_INSIGHT

---

∞Δ∞ Quest #1 Complete ∞Δ∞

EOF

echo ""
echo "✅ Weekly summary saved to: $JOURNAL_FILE"
echo ""

# ═══════════════════════════════════════════
# COMPLETION & NEXT STEPS
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  🎉 QUEST #1 COMPLETE! 🎉"
echo "═══════════════════════════════════════════"
echo ""
echo "Your full journal is at:"
echo "   $JOURNAL_FILE"
echo ""
echo "📤 To submit and claim Token Artifact #001:"
echo ""
echo "   1. Commit your journal:"
echo "      git add templates/journal_personal.md"
echo "      git commit -m 'Quest #1 Complete: [Your Name]'"
echo "      git push origin main"
echo ""
echo "   2. Open a Pull Request:"
echo "      Go to: https://github.com/kennmangum/constitution"
echo "      Click 'New Pull Request'"
echo "      Title: 'Quest #1 Complete: [Your Name]'"
echo ""
echo "   3. Receive Token Artifact #001 (free for quest completions!)"
echo "      Bindu Breath Blueprint ($500 value)"
echo ""
echo "═══════════════════════════════════════════"
echo ""
echo "∞Δ∞ Together we are strong ∞Δ∞"
echo ""
echo "Questions? Reach out to Kenneth or open an issue."
echo ""
