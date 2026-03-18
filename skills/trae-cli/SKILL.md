---
name: trae-cli
description: TRAE CLI integration for OpenClaw. Use when: (1) analyzing project architecture, (2) code review and refactoring, (3) generating documentation, (4) diagnosing code issues, (5) any TRAE CLI tasks. NOT for: local git operations (use git directly), non-TRAE related tasks, or when TRAE CLI is not installed.
metadata:
  {
    "openclaw":
      {
        "emoji": "🚀",
        "homepage": "https://docs.trae.cn/cli/get-started-with-trae-cli",
        "requires": { "bins": ["traecli"] },
        "install":
          [
            {
              "id": "install-macos-linux",
              "kind": "download",
              "label": "Install TRAE CLI (macOS/Linux)",
              "url": "https://trae.cn/trae-cli/install.sh",
              "extract": false,
              "bins": ["traecli"],
              "os": ["darwin", "linux"],
            },
            {
              "id": "install-windows",
              "kind": "download",
              "label": "Install TRAE CLI (Windows)",
              "url": "https://trae.cn/trae-cli/install.ps1",
              "extract": false,
              "bins": ["traecli"],
              "os": ["win32"],
            },
          ],
      },
  }
---

# TRAE CLI

Use the TRAE CLI to analyze projects, review code, generate documentation, and diagnose issues through natural language commands.

## When to Use

✅ **USE this skill when:**

- Analyzing project architecture and structure
- Performing code review and refactoring
- Generating API documentation or technical docs
- Diagnosing code issues and bugs
- Explaining complex codebases
- Suggesting improvements and optimizations
- Any TRAE CLI related tasks

## When NOT to Use

❌ **DON'T use this skill when:**

- Local git operations (commit, push, pull, branch) → use `git` directly
- Non-TRAE related tasks or services
- When TRAE CLI is not installed → install first using the provided scripts
- Simple file operations → use standard file tools

## Setup

### Initial Installation

TRAE CLI installation is platform-specific:

**macOS & Linux:**
```bash
sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)" && export PATH=~/.local/bin:$PATH
```

**Windows (PowerShell):**
```powershell
irm https://trae.cn/trae-cli/install.ps1 | iex
```

### Authentication

1. Run `traecli` in your terminal
2. Follow the prompts to log in with your enterprise account
3. Complete the authorization process
4. Return to TRAE CLI to start using it

### Verify Installation

```bash
traecli --version
```

## Common Commands

### Project Analysis

**Analyze project architecture:**
```bash
traecli
# Then enter: "Analyze the architecture of this project"
```

**Explain specific code:**
```bash
traecli
# Then enter: "Explain how the authentication system works in this codebase"
```

### Code Review

**Review code changes:**
```bash
traecli
# Then enter: "Review the recent changes in src/gateway/"
```

**Suggest improvements:**
```bash
traecli
# Then enter: "Suggest performance improvements for the database queries"
```

### Documentation

**Generate API docs:**
```bash
traecli
# Then enter: "Generate API documentation for the REST endpoints"
```

**Create technical docs:**
```bash
traecli
# Then enter: "Create a technical overview document for this project"
```

### Diagnostics

**Diagnose issues:**
```bash
traecli
# Then enter: "Diagnose why the authentication is failing"
```

**Find bugs:**
```bash
traecli
# Then enter: "Find potential bugs in the payment processing code"
```

## Advanced Usage

### Streaming Output

TRAE CLI provides real-time streaming output for long-running tasks. The output is displayed as it's generated, allowing you to monitor progress.

### Context-Aware Analysis

TRAE CLI automatically analyzes the current working directory and uses it as context. You can also provide specific files or directories:

```bash
cd /path/to/project
traecli
# Then enter: "Analyze the architecture"
```

### Batch Operations

For multiple similar tasks, you can chain them in a single session:

```bash
traecli
# Enter multiple commands:
# "Analyze the architecture"
# "Review the authentication code"
# "Generate API documentation"
```

## Troubleshooting

### Installation Issues

**Problem:** Command not found after installation

**Solution:**
- macOS/Linux: Add `~/.local/bin` to your PATH
- Windows: Restart your terminal or add to PATH manually

**Problem:** Installation script fails

**Solution:**
- Check your internet connection
- Ensure you have proper permissions (use sudo on Linux/macOS if needed)
- Try downloading the script manually and running it

### Authentication Issues

**Problem:** Authentication fails or expires

**Solution:**
- Run `traecli` and follow the prompts to re-authenticate
- Check your network connection
- Clear session cache: `rm ~/.openclaw/trae-cli/session.json`

### Performance Issues

**Problem:** Tasks take too long

**Solution:**
- Check your network connection to TRAE services
- Consider breaking down complex tasks into smaller ones
- Use specific, focused questions rather than broad requests

## Configuration

TRAE CLI configuration is stored in:
- `~/.traecli/` - Main configuration directory
- `~/.openclaw/trae-cli/` - OpenClaw-specific settings

Common configuration options:
- `auto_update`: Enable automatic updates (default: true)
- `timeout`: Task timeout in seconds (default: 300)
- `output_format`: Output format (markdown, json, etc.)

## Version Management

### Check Current Version
```bash
traecli --version
```

### Manual Update
```bash
traecli update
```

### Automatic Updates
TRAE CLI checks for updates on startup and will automatically update if a new version is available. A notification will be shown in the bottom-right corner.

## Notes

- Always run `traecli` from your project directory for best results
- TRAE CLI requires an active internet connection
- Enterprise authentication is required for most features
- Rate limits may apply for API calls
- Use specific, clear questions for better results
- Complex tasks may take longer to process

## Best Practices

1. **Be Specific**: Provide clear, focused questions rather than broad requests
2. **Use Context**: Run from the project directory for context-aware analysis
3. **Iterate**: Start with high-level questions, then drill down into details
4. **Verify**: Always review TRAE CLI's suggestions before implementing
5. **Document**: Keep track of useful queries and their results

## Integration with OpenClaw

This skill integrates TRAE CLI with OpenClaw, allowing you to:

- Use natural language to trigger TRAE CLI tasks
- Automatically handle authentication and session management
- Stream TRAE CLI output in real-time
- Combine TRAE CLI analysis with other OpenClaw tools

Example usage in OpenClaw:
```
User: "Analyze the architecture of this project"
OpenClaw: [Invokes trae-cli skill]
[TRAE CLI output displayed here]
```

## References

- [TRAE CLI Documentation](https://docs.trae.cn/cli/get-started-with-trae-cli)
- [TRAE Platform](https://trae.cn)
- [OpenClaw Skills Documentation](https://docs.openclaw.ai/cli/skills)
