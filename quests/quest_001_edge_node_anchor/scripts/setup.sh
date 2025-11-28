#!/usr/bin/env bash
# Quest #1 Setup Script - Edge-Node Anchor
# Installs Ollama + Mistral-7B + initializes quest files

set -euo pipefail

QUEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$QUEST_DIR/templates"
DOCS_DIR="$QUEST_DIR/docs"

echo "∞Δ∞ Quest #1 Setup - Edge-Node Anchor ∞Δ∞"
echo ""

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "📦 Ollama not found. Installing..."
    echo ""
    echo "Visit: https://ollama.ai/download"
    echo "Or run: curl https://ollama.ai/install.sh | sh"
    echo ""
    read -p "Press Enter after installing Ollama..."
else
    echo "✓ Ollama found"
fi

# Check if Mistral model is available
if ! ollama list | grep -q "mistral"; then
    echo "📦 Pulling Mistral-7B model (~4GB download)..."
    ollama pull mistral:7b
    echo "✓ Mistral-7B downloaded"
else
    echo "✓ Mistral-7B already available"
fi

# Create personal copies of templates
echo ""
echo "📝 Initializing your quest files..."

if [ ! -f "$TEMPLATES_DIR/journal_personal.md" ]; then
    cp "$TEMPLATES_DIR/journal.md" "$TEMPLATES_DIR/journal_personal.md"
    echo "✓ Created journal_personal.md"
else
    echo "⚠ journal_personal.md already exists (skipping)"
fi

if [ ! -f "$TEMPLATES_DIR/reflection_personal.md" ]; then
    cp "$TEMPLATES_DIR/reflection.md" "$TEMPLATES_DIR/reflection_personal.md"
    echo "✓ Created reflection_personal.md"
else
    echo "⚠ reflection_personal.md already exists (skipping)"
fi

# Test Ollama connection
echo ""
echo "🧪 Testing Ollama + Mistral-7B..."
TEST_RESPONSE=$(ollama run mistral:7b "Say hello" 2>&1 || echo "FAILED")

# Check if response contains reasonable AI output (not error messages)
if [[ "$TEST_RESPONSE" == *"FAILED"* ]] || [[ "$TEST_RESPONSE" == *"connection refused"* ]] || [[ "$TEST_RESPONSE" == *"Error"* ]]; then
    echo "✗ Ollama test failed. Output:"
    echo "$TEST_RESPONSE"
    echo ""
    echo "Troubleshooting:"
    echo "1. Check 'ollama serve' is running"
    echo "2. Try 'ollama run mistral:7b' manually"
    echo "3. See docs/ollama_setup.md"
    exit 1
else
    echo "✓ Ollama + Mistral-7B working"
    echo "  Response preview: ${TEST_RESPONSE:0:50}..."
fi

# Make scripts executable
chmod +x "$QUEST_DIR/scripts/daily_anchor.sh"
chmod +x "$QUEST_DIR/scripts/weekly_reflection.sh"

echo ""
echo "∞Δ∞ Setup Complete! ∞Δ∞"
echo ""
echo "Next steps:"
echo "1. Run './scripts/daily_anchor.sh' tomorrow morning"
echo "2. Journal your response in templates/journal_personal.md"
echo "3. Repeat for 7 days"
echo "4. Run './scripts/weekly_reflection.sh' on Day 7"
echo ""
echo "Questions? See README.md or docs/"
echo ""
echo "Together we are strong. <3"
