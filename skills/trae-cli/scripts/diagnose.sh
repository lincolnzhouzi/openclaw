#!/bin/bash
# diagnose.sh - Diagnose TRAE CLI installation and configuration on macOS/Linux

set -e

echo "🔍 TRAE CLI Diagnostic Tool"
echo "=========================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track issues
ISSUES=0

# Function to print check result
print_check() {
    local status=$1
    local message=$2
    
    if [ "$status" = "✓" ]; then
        echo -e "${GREEN}✓${NC} $message"
    elif [ "$status" = "✗" ]; then
        echo -e "${RED}✗${NC} $message"
        ((ISSUES++))
    else
        echo -e "${YELLOW}⚠${NC} $message"
    fi
}

# 1. Check if TRAE CLI is installed
echo "1. Installation Check"
echo "--------------------"
if command -v traecli &> /dev/null; then
    print_check "✓" "TRAE CLI is installed"
    
    # Get version
    VERSION=$(traecli --version 2>/dev/null || echo "unknown")
    print_check "✓" "Version: $VERSION"
else
    print_check "✗" "TRAE CLI is not installed"
    echo "   Install it with: sh -c \"\$(curl -L https://trae.cn/trae-cli/install.sh)\""
fi
echo ""

# 2. Check PATH
echo "2. PATH Configuration"
echo "--------------------"
if command -v traecli &> /dev/null; then
    TRAECLI_PATH=$(which traecli)
    print_check "✓" "TRAE CLI found in PATH: $TRAECLI_PATH"
else
    print_check "✗" "TRAE CLI not in PATH"
    
    # Check common locations
    if [ -f "$HOME/.local/bin/traecli" ]; then
        print_check "⚠" "Found in ~/.local/bin/traecli but not in PATH"
        echo "   Add to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
fi
echo ""

# 3. Check authentication
echo "3. Authentication Status"
echo "----------------------"
SESSION_DIR="$HOME/.openclaw/trae-cli"
SESSION_FILE="$SESSION_DIR/session.json"

if [ -f "$SESSION_FILE" ]; then
    # Check if session is valid
    if python3 -c "import json, time; data=json.load(open('$SESSION_FILE')); print('valid' if data.get('authenticated') and data.get('expires_at', 0) > time.time() else 'expired')" 2>/dev/null | grep -q "valid"; then
        print_check "✓" "Authenticated and session is valid"
    else
        print_check "✗" "Session exists but is expired or invalid"
        echo "   Run: traecli to re-authenticate"
    fi
else
    print_check "✗" "No session found"
    echo "   Run: traecli to authenticate"
fi
echo ""

# 4. Check network connectivity
echo "4. Network Connectivity"
echo "---------------------"
if curl -s --connect-timeout 5 https://trae.cn > /dev/null 2>&1; then
    print_check "✓" "Can reach TRAE services"
else
    print_check "✗" "Cannot reach TRAE services"
    echo "   Check your internet connection"
fi
echo ""

# 5. Check configuration
echo "5. Configuration"
echo "---------------"
CONFIG_FILE="$SESSION_DIR/config.json"

if [ -f "$CONFIG_FILE" ]; then
    print_check "✓" "Configuration file exists"
    
    # Validate configuration
    if python3 -c "import json; json.load(open('$CONFIG_FILE'))" 2>/dev/null; then
        print_check "✓" "Configuration is valid JSON"
    else
        print_check "✗" "Configuration is invalid JSON"
    fi
else
    print_check "⚠" "No configuration file (will use defaults)"
fi
echo ""

# 6. Check system compatibility
echo "6. System Compatibility"
echo "----------------------"
OS="$(uname -s)"
case "${OS}" in
    Linux*)     print_check "✓" "Platform: Linux (supported)";;
    Darwin*)    print_check "✓" "Platform: macOS (supported)";;
    *)          print_check "✗" "Platform: $OS (not supported)";;
esac

# Check Python version
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    print_check "✓" "Python: $PYTHON_VERSION"
else
    print_check "⚠" "Python 3 not found (required for some features)"
fi
echo ""

# 7. Summary
echo "=========================="
echo "Diagnostic Summary"
echo "=========================="

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "TRAE CLI is ready to use."
    exit 0
else
    echo -e "${RED}✗ Found $ISSUES issue(s)${NC}"
    echo ""
    echo "Please address the issues above before using TRAE CLI."
    exit 1
fi
