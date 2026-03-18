# TRAE CLI Troubleshooting Guide

This guide helps you diagnose and resolve common issues with TRAE CLI.

## Installation Issues

### Issue: Command Not Found

**Symptoms:**
```
traecli: command not found
```

**Causes:**
1. TRAE CLI not installed
2. Installation directory not in PATH
3. Shell configuration not updated

**Solutions:**

**Solution 1: Install TRAE CLI**
```bash
# macOS/Linux
sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)"

# Windows PowerShell
irm https://trae.cn/trae-cli/install.ps1 | iex
```

**Solution 2: Add to PATH (macOS/Linux)**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

**Solution 3: Add to PATH (Windows)**
1. Open System Properties → Environment Variables
2. Edit PATH variable
3. Add `C:\Users\YourUsername\.local\bin`
4. Restart terminal

### Issue: Installation Script Fails

**Symptoms:**
```
curl: (7) Failed to connect to trae.cn
```

**Causes:**
1. Network connectivity issues
2. Firewall blocking connection
3. DNS resolution problems

**Solutions:**

**Solution 1: Check Network**
```bash
# Test connectivity
ping trae.cn
curl -I https://trae.cn
```

**Solution 2: Check Firewall**
- Ensure outbound HTTPS connections are allowed
- Check corporate firewall settings
- Try from a different network

**Solution 3: Check DNS**
```bash
# Test DNS resolution
nslookup trae.cn
dig trae.cn
```

### Issue: Permission Denied

**Symptoms:**
```
Permission denied: ~/.local/bin/traecli
```

**Causes:**
1. Insufficient permissions to write to installation directory
2. Directory ownership issues

**Solutions:**

**Solution 1: Use sudo (Linux/macOS)**
```bash
sudo sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)"
```

**Solution 2: Fix Directory Permissions**
```bash
# Create directory with correct permissions
mkdir -p ~/.local/bin
chmod 755 ~/.local/bin

# Install again
sh -c "$(curl -L https://trae.cn/trae-cli/install.sh)"
```

## Authentication Issues

### Issue: Not Authenticated

**Symptoms:**
```
Error: Not authenticated
Please run: traecli
```

**Causes:**
1. Never authenticated
2. Session expired
3. Session corrupted

**Solutions:**

**Solution 1: Authenticate**
```bash
traecli
# Follow prompts to log in with your enterprise account
```

**Solution 2: Clear Session and Re-authenticate**
```bash
# Remove session files
rm ~/.traecli/session.json
rm ~/.traecli/auth_token.json

# Re-authenticate
traecli
```

**Solution 3: Check Session Status**
```bash
# Run diagnostic tool
python3 ~/.openclaw/skills/trae-cli/scripts/diagnose.py
```

### Issue: Authentication Fails

**Symptoms:**
```
Error: Authentication failed
Please check your credentials and try again
```

**Causes:**
1. Incorrect credentials
2. Enterprise account issues
3. Network problems during authentication

**Solutions:**

**Solution 1: Verify Credentials**
- Ensure you're using the correct enterprise account
- Check that your account is active
- Contact your IT administrator if needed

**Solution 2: Check Network**
```bash
# Test connectivity to TRAE services
curl -I https://trae.cn
```

**Solution 3: Try Again Later**
- Authentication service may be temporarily unavailable
- Wait a few minutes and try again

### Issue: Session Expires Frequently

**Symptoms:**
- Need to re-authenticate frequently
- Session expires before expected

**Causes:**
1. Session timeout too short
2. Network issues causing session invalidation
3. Concurrent sessions

**Solutions:**

**Solution 1: Increase Session Timeout**
```json
// ~/.traecli/config.json
{
  "session": {
    "timeout": 7200
  }
}
```

**Solution 2: Check Network Stability**
- Ensure stable network connection
- Avoid switching networks during use

**Solution 3: Avoid Concurrent Sessions**
- Use only one TRAE CLI session at a time
- Close other sessions before starting new ones

## Execution Issues

### Issue: Task Times Out

**Symptoms:**
```
Error: Task timed out after 300 seconds
```

**Causes:**
1. Task is too complex
2. Network latency
3. TRAE service load

**Solutions:**

**Solution 1: Increase Timeout**
```json
// ~/.traecli/config.json
{
  "timeout": 600
}
```

**Solution 2: Break Down Task**
- Divide complex tasks into smaller parts
- Execute each part separately
- Combine results as needed

**Solution 3: Use More Specific Prompts**
- Be more specific in your requests
- Focus on particular areas or files
- Reduce scope of analysis

### Issue: No Output or Empty Response

**Symptoms:**
- TRAE CLI runs but produces no output
- Empty response returned

**Causes:**
1. Prompt too vague
2. Context not provided
3. TRAE service issue

**Solutions:**

**Solution 1: Use More Specific Prompts**
```bash
# Instead of:
traecli "Analyze this"

# Use:
traecli "Analyze the authentication system in src/auth.ts"
```

**Solution 2: Provide Context**
```bash
# Run from project directory
cd /path/to/project
traecli "Analyze the architecture"
```

**Solution 3: Enable Verbose Output**
```bash
traecli --verbose
```

### Issue: Incorrect or Poor Quality Results

**Symptoms:**
- Results don't match expectations
- Analysis is inaccurate
- Suggestions are irrelevant

**Causes:**
1. Insufficient context
2. Ambiguous prompts
3. Outdated code or documentation

**Solutions:**

**Solution 1: Provide Better Context**
```bash
# Specify files to analyze
traecli "Review the authentication code in src/auth.ts and src/user.ts"
```

**Solution 2: Use Clear, Specific Prompts**
```bash
# Instead of:
traecli "Review the code"

# Use:
traecli "Review the authentication code for security vulnerabilities and suggest improvements"
```

**Solution 3: Iterate and Refine**
- Start with high-level analysis
- Ask follow-up questions
- Focus on specific areas

## Network Issues

### Issue: Cannot Connect to TRAE Services

**Symptoms:**
```
Error: Failed to connect to TRAE services
```

**Causes:**
1. Network connectivity issues
2. Firewall blocking
3. Proxy configuration

**Solutions:**

**Solution 1: Check Network**
```bash
# Test connectivity
ping trae.cn
curl -I https://trae.cn
```

**Solution 2: Check Firewall**
- Ensure outbound HTTPS (port 443) is allowed
- Check corporate firewall settings
- Add TRAE domains to whitelist

**Solution 3: Configure Proxy**
```bash
# Set proxy environment variables
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080

# Or in config.json
{
  "proxy": {
    "http": "http://proxy.example.com:8080",
    "https": "http://proxy.example.com:8080"
  }
}
```

### Issue: Slow Response Times

**Symptoms:**
- TRAE CLI takes a long time to respond
- Streaming output is slow

**Causes:**
1. Network latency
2. TRAE service load
3. Large task complexity

**Solutions:**

**Solution 1: Check Network Speed**
```bash
# Test network speed
speedtest-cli
```

**Solution 2: Use Smaller Tasks**
- Break down large tasks
- Process files individually
- Use more focused prompts

**Solution 3: Check TRAE Service Status**
- Visit https://status.trae.cn
- Check for service outages
- Monitor social media for updates

## Configuration Issues

### Issue: Configuration Not Applied

**Symptoms:**
- Configuration changes don't take effect
- Default values still used

**Causes:**
1. Incorrect configuration file location
2. Invalid JSON syntax
3. Configuration file not reloaded

**Solutions:**

**Solution 1: Verify Configuration Location**
```bash
# Check configuration file exists
ls -la ~/.traecli/config.json

# Or for OpenClaw skill
ls -la ~/.openclaw/trae-cli/config.json
```

**Solution 2: Validate JSON**
```bash
# Validate JSON syntax
python3 -m json.tool ~/.traecli/config.json
```

**Solution 3: Restart TRAE CLI**
- Close and reopen terminal
- Restart any running TRAE CLI sessions

### Issue: Invalid Configuration

**Symptoms:**
```
Error: Invalid configuration file
```

**Causes:**
1. JSON syntax errors
2. Invalid configuration values
3. Missing required fields

**Solutions:**

**Solution 1: Validate JSON**
```bash
# Check for syntax errors
python3 -m json.tool ~/.traecli/config.json
```

**Solution 2: Reset Configuration**
```bash
# Remove configuration file
rm ~/.traecli/config.json

# TRAE CLI will use defaults
traecli
```

**Solution 3: Use Example Configuration**
```json
{
  "version": "1.0.0",
  "auto_update": true,
  "timeout": 300,
  "output_format": "markdown",
  "verbose": false
}
```

## Performance Issues

### Issue: High Memory Usage

**Symptoms:**
- TRAE CLI uses excessive memory
- System becomes slow

**Causes:**
1. Large codebase analysis
2. Multiple concurrent sessions
3. Memory leak

**Solutions:**

**Solution 1: Analyze Smaller Scope**
- Focus on specific directories
- Analyze files individually
- Use more targeted prompts

**Solution 2: Close Unused Sessions**
- Ensure only one TRAE CLI session is running
- Close terminal sessions when done

**Solution 3: Restart TRAE CLI**
- Exit and restart TRAE CLI
- Clear session cache

### Issue: Slow Startup

**Symptoms:**
- TRAE CLI takes a long time to start
- Initial authentication is slow

**Causes:**
1. Network latency
2. Large session files
3. Outdated version

**Solutions:**

**Solution 1: Check Network**
```bash
# Test connectivity
ping trae.cn
```

**Solution 2: Clear Session Cache**
```bash
# Remove session files
rm ~/.traecli/session.json
rm ~/.traecli/auth_token.json
```

**Solution 3: Update TRAE CLI**
```bash
traecli update
```

## Getting Help

### Diagnostic Tool

Run the diagnostic tool to identify issues:

```bash
# macOS/Linux
bash ~/.openclaw/skills/trae-cli/scripts/diagnose.sh

# Windows
powershell -File ~/.openclaw/skills/trae-cli/scripts/diagnose.ps1

# Or using Python
python3 ~/.openclaw/skills/trae-cli/scripts/diagnose.py
```

### Verbose Logging

Enable verbose logging for detailed information:

```bash
traecli --verbose
```

### Check Logs

TRAE CLI logs are stored in:
- `~/.traecli/logs/` - TRAE CLI logs
- `~/.openclaw/trae-cli/logs/` - OpenClaw skill logs

### Contact Support

If issues persist:

1. Check [TRAE CLI Documentation](https://docs.trae.cn/cli/get-started-with-trae-cli)
2. Visit [TRAE Status Page](https://status.trae.cn)
3. Contact TRAE support through your enterprise account
4. Report issues on [GitHub](https://github.com/trae/trae-cli/issues)

## Common Error Messages

| Error Message | Cause | Solution |
|--------------|--------|----------|
| `traecli: command not found` | Not installed or not in PATH | Install TRAE CLI or add to PATH |
| `Not authenticated` | Session expired or not authenticated | Run `traecli` to authenticate |
| `Task timed out` | Task too complex or network issue | Increase timeout or break down task |
| `Failed to connect to TRAE services` | Network issue | Check network connection |
| `Invalid configuration file` | JSON syntax error | Validate and fix configuration |
| `Rate limit exceeded` | Too many requests | Wait and retry later |

## Prevention Tips

1. **Keep Updated**: Regularly run `traecli update`
2. **Monitor Usage**: Watch for rate limit warnings
3. **Maintain Network**: Ensure stable network connection
4. **Validate Config**: Regularly check configuration files
5. **Use Specific Prompts**: Be clear and specific in requests
6. **Monitor Resources**: Watch memory and CPU usage
7. **Clear Cache**: Periodically clear session cache

## Additional Resources

- [TRAE CLI API Reference](api.md)
- [Usage Examples](examples.md)
- [TRAE CLI Documentation](https://docs.trae.cn/cli/get-started-with-trae-cli)
- [OpenClaw Skills Documentation](https://docs.openclaw.ai/cli/skills)
