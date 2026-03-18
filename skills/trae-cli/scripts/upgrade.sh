#!/bin/bash
# upgrade.sh - Upgrade TRAE CLI on macOS/Linux

set -e

echo "🔄 TRAE CLI Upgrade Tool"
echo "======================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if TRAE CLI is installed
if ! command -v traecli &> /dev/null; then
    echo -e "${RED}✗ TRAE CLI is not installed${NC}"
    echo "Please install it first with: sh -c \"\$(curl -L https://trae.cn/trae-cli/install.sh)\""
    exit 1
fi

# Get current version
echo "📌 Current version:"
CURRENT_VERSION=$(traecli --version 2>/dev/null || echo "unknown")
echo "$CURRENT_VERSION"
echo ""

# Check for updates
echo "🔍 Checking for updates..."
echo "This may take a moment..."
echo ""

# Run TRAE CLI update command
if traecli update; then
    echo ""
    echo -e "${GREEN}✓ Upgrade successful!${NC}"
    
    # Get new version
    NEW_VERSION=$(traecli --version 2>/dev/null || echo "unknown")
    echo ""
    echo "📌 New version: $NEW_VERSION"
    echo ""
    echo "🎉 TRAE CLI has been upgraded to the latest version!"
else
    echo ""
    echo -e "${RED}✗ Upgrade failed${NC}"
    echo ""
    echo "Possible reasons:"
    echo "1. Network connection issues"
    echo "2. TRAE CLI update service is temporarily unavailable"
    echo "3. You already have the latest version"
    echo ""
    echo "Please try again later or check the TRAE CLI documentation."
    exit 1
fi
