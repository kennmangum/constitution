#!/usr/bin/env bash
# Quest #1 Daily Anchor Script - ROE Verification
# Runs morning sovereignty check using local Ollama + Mistral

set -euo pipefail

QUEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_FILE="$QUEST_DIR/templates/journal_personal.md"
TODAY=$(date +%Y-%m-%d)

echo "∞Δ∞ Morning Anchor ∞Δ∞"
echo ""
echo "📁 Your journal: $JOURNAL_FILE"
echo ""

# Check if Ollama is running
if ! command -v ollama &> /dev/null; then
    echo "✗ Ollama not found. Run setup.sh first."
    exit 1
fi

# Helper function to validate numeric input
validate_number() {
    local input=$1
    if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -le 10 ]; then
        return 0
    else
        return 1
    fi
}

# ═══════════════════════════════════════════
# STEP 1: Identify YOUR Next Action
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 1: What's your next action?"
echo "═══════════════════════════════════════════"
echo ""
echo "Think of ONE thing you plan to do today."
echo "(Work: 'Draft IEP for Alex' / Life: 'Call mom' / Anything that matters to you)"
echo ""
read -p "My next action: " NEXT_ACTION
echo ""

# ═══════════════════════════════════════════
# STEP 2: Score That Action (ROE Check)
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 2: Score YOUR action (0-10 each)"
echo "═══════════════════════════════════════════"
echo ""
echo "Now score that action. Go with your gut!"
echo ""

# Question 1: Clarity
while true; do
    read -p "1. CLARITY: Is the path to this action clear? (0=foggy, 10=crystal clear): " CLARITY
    if validate_number "$CLARITY"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10"
    fi
done

# Question 2: Alignment
while true; do
    read -p "2. ALIGNMENT: Does this serve YOUR deepest purpose? (0=external pressure, 10=totally mine): " ALIGNMENT
    if validate_number "$ALIGNMENT"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10"
    fi
done

# Question 3: Groundedness
while true; do
    read -p "3. GROUNDEDNESS: Does this feel rooted in who you are? (0=chasing haze, 10=deeply me): " GROUNDEDNESS
    if validate_number "$GROUNDEDNESS"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10"
    fi
done

# Calculate ROE score (works without bc - cross-platform)
ROE_SUM=$((CLARITY + ALIGNMENT + GROUNDEDNESS))
ROE_PERCENT=$(( (ROE_SUM * 100) / 30 ))
ROE_SCORE="0.$(printf '%02d' $ROE_PERCENT)"
if [ "$ROE_SUM" -eq 30 ]; then
    ROE_SCORE="1.00"
fi

echo ""
echo "═══════════════════════════════════════════"
echo "  YOUR ROE SCORE: $ROE_SCORE ($ROE_SUM/30)"
echo "═══════════════════════════════════════════"

# Interpret ROE
if [ "$ROE_PERCENT" -gt 80 ]; then
    echo "  🟢 High Resonance — You're aligned. Trust it."
    ROE_STATUS="🟢 High Resonance"
elif [ "$ROE_PERCENT" -gt 60 ]; then
    echo "  🟡 Moderate Resonance — Some drift. Is this really yours?"
    ROE_STATUS="🟡 Moderate Resonance"
else
    echo "  🔴 Low Resonance — Pause. What agenda are you serving?"
    ROE_STATUS="🔴 Low Resonance"
fi

echo "═══════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════
# STEP 3: AI Reflection (Ollama)
# ═══════════════════════════════════════════
echo "🤖 Generating reflection prompt..."
echo ""

PROMPT="You are a gentle guide. Someone scored their next action '$NEXT_ACTION' with Clarity=$CLARITY, Alignment=$ALIGNMENT, Groundedness=$GROUNDEDNESS (ROE=$ROE_SCORE). Generate ONE short reflection question (max 15 words) to help them deepen. No productivity advice. Focus on their inner truth."

REFLECTION_PROMPT=$(ollama run mistral "$PROMPT" 2>/dev/null | grep -v '^$' | head -1)

echo "💭 Reflection Prompt:"
echo "   $REFLECTION_PROMPT"
echo ""

# Guidance based on ROE
echo "📌 Today's Guidance:"
if [ "$ROE_PERCENT" -gt 80 ]; then
    echo "   You're aligned. Execute with presence."
elif [ "$ROE_PERCENT" -gt 60 ]; then
    echo "   Check in: Is '$NEXT_ACTION' truly yours, or an echo of someone else's agenda?"
else
    echo "   Consider pausing '$NEXT_ACTION'. Journal: What's driving this?"
fi

echo ""

# ═══════════════════════════════════════════
# STEP 4: Your Reflection (Inline Journaling)
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  STEP 4: Your Reflection"
echo "═══════════════════════════════════════════"
echo ""
echo "Take a moment. Respond to the reflection prompt above."
echo "(1-2 sentences, or as much as you'd like)"
echo ""
echo "Type your reflection, then press ENTER:"
read -p "> " MY_REFLECTION
echo ""

# ═══════════════════════════════════════════
# SAVE TO JOURNAL (Auto-append)
# ═══════════════════════════════════════════
echo "═══════════════════════════════════════════"
echo "  💾 Saving to your journal..."
echo "═══════════════════════════════════════════"

# Append entry to journal file
cat >> "$JOURNAL_FILE" << EOF

---

## $TODAY

**Next Action**: $NEXT_ACTION

**ROE Score**: $ROE_SCORE ($ROE_SUM/30) — $ROE_STATUS
- Clarity: $CLARITY/10
- Alignment: $ALIGNMENT/10
- Groundedness: $GROUNDEDNESS/10

**Reflection Prompt**: $REFLECTION_PROMPT

**My Reflection**: $MY_REFLECTION

EOF

echo ""
echo "✅ Entry saved to: $JOURNAL_FILE"
echo ""
echo "═══════════════════════════════════════════"
echo ""
echo "∞Δ∞ Anchor complete! ∞Δ∞"
echo ""
echo "📖 To view your full journal:"
echo "   cat $JOURNAL_FILE"
echo ""
echo "📅 Tomorrow: Run this script again"
echo "📅 Day 7: Run './scripts/weekly_reflection.sh'"
echo ""
echo "💡 TIP: Pull latest updates before each session:"
echo "   cd ~/constitution && git fetch upstream && git merge upstream/main"
echo ""
