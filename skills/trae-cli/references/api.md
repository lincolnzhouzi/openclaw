# TRAE CLI API Reference

This document provides detailed information about TRAE CLI commands, options, and usage patterns.

## Core Commands

### `traecli`

The main TRAE CLI command. Running without arguments starts the interactive CLI.

**Usage:**
```bash
traecli [options]
```

**Options:**
- `--version`: Display TRAE CLI version
- `--help`: Display help information
- `--non-interactive`: Run in non-interactive mode
- `--json`: Output in JSON format
- `--verbose`: Enable verbose output

### `traecli update`

Update TRAE CLI to the latest version.

**Usage:**
```bash
traecli update
```

**Behavior:**
- Checks for available updates
- Downloads and installs the latest version
- Displays progress and status

### `traecli --version`

Display the current TRAE CLI version.

**Usage:**
```bash
traecli --version
```

**Output:**
```
TRAE CLI v1.2.3
```

## Interactive Mode

When you run `traecli` without arguments, it starts in interactive mode where you can:

1. Enter natural language prompts
2. Receive real-time responses
3. Maintain conversation context
4. Execute multiple tasks in a single session

**Example Session:**
```
$ traecli

Welcome to TRAE CLI v1.2.3
You are authenticated as user@example.com

> Analyze the architecture of this project
[Analyzing project structure...]
[Processing code files...]
[Generating analysis...]

This project follows a microservices architecture with:
- Gateway service for API routing
- Auth service for authentication
- Data service for data persistence
...

> Review the authentication code
[Reviewing authentication implementation...]
[Checking security best practices...]

The authentication code is well-structured but could benefit from:
- Adding rate limiting
- Implementing token rotation
- Enhanced error handling
...
```

## Non-Interactive Mode

For automation and scripting, use non-interactive mode with JSON input/output.

**Usage:**
```bash
echo '{"prompt": "Analyze this project"}' | traecli --non-interactive --json
```

**Input Format (JSON):**
```json
{
  "prompt": "Natural language prompt for the task",
  "context": {
    "project_path": "/path/to/project",
    "files": ["file1.ts", "file2.ts"],
    "focus": "specific area to focus on"
  }
}
```

**Output Format (JSON):**
```json
{
  "success": true,
  "result": "Task result text",
  "metadata": {
    "task_id": "abc123",
    "duration_ms": 1500,
    "model": "trae-4"
  }
}
```

## Context-Aware Analysis

TRAE CLI automatically analyzes the current working directory and uses it as context.

**Best Practices:**
1. Always run `traecli` from your project root
2. Ensure all relevant files are accessible
3. Use specific prompts for better results

**Example:**
```bash
cd /path/to/my-project
traecli
# Then enter: "Analyze the architecture"
```

## Streaming Output

TRAE CLI provides real-time streaming output for long-running tasks.

**Behavior:**
- Output is displayed as it's generated
- Progress indicators show task completion
- Large responses are chunked for readability

**Example:**
```
> Generate API documentation for all endpoints
[Progress: 10%] Analyzing API routes...
[Progress: 30%] Extracting endpoint definitions...
[Progress: 60%] Generating documentation content...
[Progress: 90%] Formatting output...
[Progress: 100%] Complete!

# API Documentation

## Authentication Endpoints

### POST /auth/login
Authenticate user with credentials...

```

## Error Handling

TRAE CLI provides detailed error messages to help diagnose issues.

**Common Errors:**

### Authentication Error
```
Error: Not authenticated
Please run: traecli
Follow the prompts to authenticate with your enterprise account
```

**Solution:** Run `traecli` and complete authentication

### Network Error
```
Error: Failed to connect to TRAE services
Please check your internet connection and try again
```

**Solution:** Check network connectivity and retry

### Timeout Error
```
Error: Task timed out after 300 seconds
Consider breaking down the task into smaller parts
```

**Solution:** Use more focused prompts or increase timeout

## Rate Limiting

TRAE CLI has rate limits to ensure fair usage.

**Limits:**
- Requests per minute: Varies by plan
- Concurrent sessions: 1 per user
- Token usage: Varies by plan

**Behavior:**
- When limits are reached, TRAE CLI will queue requests
- You'll be notified when you're approaching limits
- Premium plans have higher limits

## Authentication

TRAE CLI uses enterprise authentication for access.

**Authentication Flow:**
1. Run `traecli`
2. Follow prompts to log in with your enterprise account
3. Complete authorization in browser
4. Return to terminal to start using TRAE CLI

**Session Management:**
- Sessions are stored locally
- Sessions expire after 1 hour (configurable)
- Automatic re-authentication when needed

**Session Storage:**
- `~/.traecli/session.json` - Session data
- `~/.traecli/auth_token.json` - Authentication tokens

## Configuration

TRAE CLI can be configured via configuration file or environment variables.

**Configuration File:** `~/.traecli/config.json`

**Example Configuration:**
```json
{
  "version": "1.0.0",
  "auto_update": true,
  "timeout": 300,
  "output_format": "markdown",
  "verbose": false
}
```

**Environment Variables:**
- `TRAECLI_TIMEOUT`: Task timeout in seconds
- `TRAECLI_OUTPUT_FORMAT`: Output format (markdown, json, text)
- `TRAECLI_VERBOSE`: Enable verbose logging (true/false)
- `TRAECLI_AUTO_UPDATE`: Enable automatic updates (true/false)

## Advanced Usage

### Batch Processing

Process multiple tasks in a single session:

```bash
traecli << EOF
Analyze the architecture
Review the authentication code
Generate API documentation
EOF
```

### Custom Context

Provide specific context for analysis:

```bash
echo '{
  "prompt": "Review the code",
  "context": {
    "files": ["src/auth.ts", "src/user.ts"],
    "focus": "security"
  }
}' | traecli --non-interactive --json
```

### Output Redirection

Save output to file:

```bash
traecli --non-interactive < input.txt > output.md
```

## Integration Examples

### With OpenClaw

```python
from scripts.execute import execute_task

result = execute_task("Analyze project architecture")
print(result)
```

### With Shell Scripts

```bash
#!/bin/bash
# Analyze project and save report
traecli --non-interactive << EOF > report.md
Analyze the architecture of this project
Focus on scalability and maintainability
EOF
```

### With CI/CD

```yaml
# GitHub Actions example
- name: Analyze code with TRAE CLI
  run: |
    echo '{"prompt": "Review recent changes"}' | traecli --non-interactive --json
```

## Best Practices

1. **Be Specific**: Use clear, focused prompts
2. **Provide Context**: Run from project directory
3. **Iterate**: Start with high-level questions, then drill down
4. **Verify**: Review suggestions before implementing
5. **Monitor**: Watch for rate limit warnings

## Troubleshooting

See [troubleshooting.md](troubleshooting.md) for detailed troubleshooting information.

## Additional Resources

- [TRAE CLI Documentation](https://docs.trae.cn/cli/get-started-with-trae-cli)
- [TRAE Platform](https://trae.cn)
- [OpenClaw Skills Documentation](https://docs.openclaw.ai/cli/skills)
