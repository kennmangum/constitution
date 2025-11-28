#!/usr/bin/env bash
# Quest #1 Daily Anchor Script - ROE Verification
# Runs morning sovereignty check using local Ollama + Mistral-7B

set -euo pipefail

QUEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_FILE="$QUEST_DIR/templates/journal_personal.md"

echo "∞Δ∞ Morning Anchor - Day $(date +%u)/7 ∞Δ∞"
echo ""

# Check if Ollama is running
if ! command -v ollama &> /dev/null; then
    echo "✗ Ollama not found. Run setup.sh first."
    exit 1
fi

# ROE Interview (Simplified for Quest #1)
echo "📋 Quick ROE Check (3 questions, NUMBERS ONLY: 0-10)"
echo ""
echo "Instructions: Enter a number from 0 (not at all) to 10 (completely)"
echo "Don't overthink it - go with your gut feeling!"
echo ""

# Helper function to validate numeric input
validate_number() {
    local input=$1
    if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -le 10 ]; then
        return 0
    else
        return 1
    fi
}

# Question 1: Clarity
while true; do
    read -p "1. Clarity: Is your next action clear? (Enter 0-10): " CLARITY
    if validate_number "$CLARITY"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10 (e.g., 7)"
    fi
done

# Question 2: Alignment
while true; do
    read -p "2. Alignment: Does it serve Lasting Generational Prosperity? (Enter 0-10): " ALIGNMENT
    if validate_number "$ALIGNMENT"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10 (e.g., 8)"
    fi
done

# Question 3: Groundedness
while true; do
    read -p "3. Groundedness: Does it feel like YOUR choice (not someone else's)? (Enter 0-10): " GROUNDEDNESS
    if validate_number "$GROUNDEDNESS"; then
        break
    else
        echo "   ⚠ Please enter a NUMBER between 0 and 10 (e.g., 9)"
    fi
done

# Calculate ROE score
ROE_SUM=$((CLARITY + ALIGNMENT + GROUNDEDNESS))
ROE_SCORE=$(echo "scale=2; $ROE_SUM / 30" | bc)

echo ""
echo "═══════════════════════════════════════════"
echo "  ROE Score: $ROE_SCORE"
echo "═══════════════════════════════════════════"

# Interpret ROE
if (( $(echo "$ROE_SCORE > 0.8" | bc -l) )); then
    echo "  Status: 🟢 High Resonance (breathing with origin)"
elif (( $(echo "$ROE_SCORE > 0.6" | bc -l) )); then
    echo "  Status: 🟡 Moderate Resonance (some drift, course-correct)"
else
    echo "  Status: 🔴 Low Resonance (pause, re-evaluate)"
fi

echo "═══════════════════════════════════════════"
echo ""

# Generate reflection prompt using Ollama
echo "🤖 Generating reflection prompt (Ollama + Mistral-7B)..."
echo ""

PROMPT="You are a sovereignty guide. Based on this ROE score ($ROE_SCORE, where Clarity=$CLARITY, Alignment=$ALIGNMENT, Groundedness=$GROUNDEDNESS), generate ONE reflection question (max 20 words) that helps the person deepen their practice. Focus on origin energy, not productivity hacks."

REFLECTION_PROMPT=$(ollama run mistral:7b "$PROMPT" 2>/dev/null | head -3 | tail -1)

echo "Reflection Prompt:"
echo "  $REFLECTION_PROMPT"
echo ""

# Suggest next action based on ROE
echo "📌 Today's Guidance:"
if (( $(echo "$ROE_SCORE > 0.8" | bc -l) )); then
    echo "  - You're aligned. Trust the breath. Execute with presence."
elif (( $(echo "$ROE_SCORE > 0.6" | bc -l) )); then
    echo "  - Moderate drift detected. Review your next action: Is it yours or an echo?"
else
    echo "  - Low resonance. Pause execution. Journal: 'What agenda am I serving?'"
fi

echo ""
echo "═══════════════════════════════════════════"
echo ""

# Save to journal helper (manual paste for now, auto-append in V2)
echo "📝 Copy this to your journal (templates/journal_personal.md):"
echo ""
echo "## Day $(date +%u): $(date +%Y-%m-%d)"
echo ""
echo "**Morning Anchor Output**:"
echo "- ROE Score: $ROE_SCORE"
echo "- Reflection Prompt: $REFLECTION_PROMPT"
echo ""
echo "**Journal Entry** (1-2 sentences):"
echo "[Paste your reflection here]"
echo ""

echo "∞Δ∞ Anchor complete. Journal your response. ∞Δ∞"
echo ""
echo "Tomorrow: Run this script again (Days 1-7)"
echo "Day 7: Run './scripts/weekly_reflection.sh'"
