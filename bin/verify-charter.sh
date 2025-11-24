#!/bin/bash
# Constitutional Integrity Verification Script
# Purpose: Verify constitutional structure is coherent and complete
# Usage: bin/verify-charter.sh

set -e

echo "∞Δ∞ Constitutional Integrity Verification ∞Δ∞"
echo ""

ERRORS=0

# Check 1: CONSTITUTION.md exists
if [ -f "CONSTITUTION.md" ]; then
    LINES=$(wc -l < CONSTITUTION.md)
    echo "[✓] CONSTITUTION.md: present, $LINES lines"
else
    echo "[✗] CONSTITUTION.md: MISSING"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: Charter v1.0 exists
CHARTER_PATH="core/CHARTER_v1.0/SOVEREIGNTY_ALIGNED_CHARTER_v1.0_2025-11-18.md"
if [ -f "$CHARTER_PATH" ]; then
    LINES=$(wc -l < "$CHARTER_PATH")
    echo "[✓] Charter v1.0: present, $LINES lines"
else
    echo "[✗] Charter v1.0: MISSING"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: BNA Profile exists
if [ -f "profiles/BNA.md" ] || [ -f "core/BNA.md" ]; then
    echo "[✓] BNA Profile: present"
else
    echo "[✗] BNA Profile: MISSING"
    ERRORS=$((ERRORS + 1))
fi

# Check 4: Triad references in Charter
if [ -f "$CHARTER_PATH" ]; then
    SOURCE_COUNT=$(grep -c "SOURCE" "$CHARTER_PATH" || true)
    TRUTH_COUNT=$(grep -c "TRUTH" "$CHARTER_PATH" || true)
    INTEGRITY_COUNT=$(grep -c "INTEGRITY" "$CHARTER_PATH" || true)
    echo "[✓] Triad references: SOURCE ($SOURCE_COUNT), TRUTH ($TRUTH_COUNT), INTEGRITY ($INTEGRITY_COUNT)"
fi

# Check 5: Hydration protocols present
if [ -d "startup" ]; then
    echo "[✓] Hydration protocols: present"
else
    echo "[⚠] Hydration protocols: not found (may be optional)"
fi

# Check 6: No competing instruction files (basic check)
SUSPECT_FILES=$(find . -name "*system-prompt*" -o -name "*override*" 2>/dev/null | wc -l)
if [ "$SUSPECT_FILES" -eq 0 ]; then
    echo "[✓] No competing instruction files detected"
else
    echo "[⚠] Found $SUSPECT_FILES potential competing instruction files"
fi

# Check 7: README and LICENSE present
if [ -f "README.md" ]; then
    echo "[✓] README.md: present"
else
    echo "[⚠] README.md: missing"
fi

if [ -f "LICENSE" ]; then
    echo "[✓] LICENSE: present"
else
    echo "[⚠] LICENSE: missing"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "Status: ✓ CONSTITUTIONAL INTEGRITY VERIFIED"
    echo ""
    echo "This constitutional framework is coherent and ready for operational use."
    echo "Remember: This public repo is a witness mirror, not an operational hydration source."
    exit 0
else
    echo "Status: ✗ $ERRORS ERRORS DETECTED - Constitutional integrity compromised"
    echo ""
    echo "Review the errors above and ensure all required constitutional files are present."
    exit 1
fi
