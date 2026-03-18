#!/bin/bash
# install_traecli.sh - Install TRAE CLI on macOS and Linux

set -e

echo "🚀 Installing TRAE CLI..."

# Check if running on supported platform
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=linux;;
    Darwin*)    PLATFORM=macos;;
    *)          echo "❌ Unsupported platform: ${OS}"; exit 1;;
esac

echo "📦 Detected platform: ${PLATFORM}"

# Download and run official installer
if [ "${PLATFORM}" = "macos" ]; then
    echo "⬇️  Downloading TRAE CLI for macOS..."
    sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)"
elif [ "${PLATFORM}" = "linux" ]; then
    echo "⬇️  Downloading TRAE CLI for Linux..."
    sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)"
fi

# Add to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "⚠️  Adding ~/.local/bin to PATH..."
    
    # Detect shell and add to appropriate config file
    SHELL_CONFIG=""
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    
    if [ -n "$SHELL_CONFIG" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
        echo "✅ Added to $SHELL_CONFIG"
        echo "📝 Please run: source $SHELL_CONFIG"
    else
        echo "⚠️  Please add ~/.local/bin to your PATH manually"
    fi
fi

# Verify installation
echo ""
echo "🔍 Verifying installation..."
if command -v traecli &> /dev/null; then
    VERSION=$(traecli --version 2>/dev/null || echo "unknown")
    echo "✅ TRAE CLI installed successfully!"
    echo "📌 Version: $VERSION"
    echo ""
    echo "🎉 Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Run: traecli"
    echo "2. Follow the prompts to authenticate with your enterprise account"
    echo "3. Start using TRAE CLI!"
else
    echo "❌ Installation verification failed"
    echo "Please check the error messages above"
    exit 1
fi
