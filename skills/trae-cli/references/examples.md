# TRAE CLI Usage Examples

This document provides practical examples of using TRAE CLI for common tasks.

## Project Analysis

### Analyze Project Architecture

**Basic Architecture Analysis:**
```bash
traecli
> Analyze the architecture of this project
```

**Focus on Specific Areas:**
```bash
traecli
> Analyze the authentication system architecture
```

**Compare Multiple Architectures:**
```bash
traecli
> Compare the architecture of the frontend and backend services
```

### Code Structure Analysis

**Analyze Directory Structure:**
```bash
traecli
> Analyze the directory structure and explain the organization
```

**Identify Patterns:**
```bash
traecli
> Identify design patterns used in this codebase
```

**Analyze Dependencies:**
```bash
traecli
> Analyze the dependencies and their relationships
```

## Code Review

### Review Code Changes

**Review Specific File:**
```bash
traecli
> Review the authentication code in src/auth.ts
```

**Review Multiple Files:**
```bash
traecli
> Review the changes in src/auth.ts, src/user.ts, and src/session.ts
```

**Review Recent Changes:**
```bash
traecli
> Review the recent changes in the gateway module
```

### Security Review

**Security Audit:**
```bash
traecli
> Perform a security audit of the authentication system
```

**Vulnerability Scan:**
```bash
traecli
> Identify potential security vulnerabilities in the payment processing code
```

**Compliance Check:**
```bash
traecli
> Check if this code complies with OWASP security guidelines
```

### Performance Review

**Performance Analysis:**
```bash
traecli
> Analyze the performance of the database queries
```

**Optimization Suggestions:**
```bash
traecli
> Suggest performance optimizations for the API endpoints
```

**Bottleneck Identification:**
```bash
traecli
> Identify performance bottlenecks in the data processing pipeline
```

## Documentation Generation

### API Documentation

**Generate API Docs:**
```bash
traecli
> Generate API documentation for all REST endpoints
```

**Generate Specific API Docs:**
```bash
traecli
> Generate documentation for the authentication API
```

**Generate OpenAPI Spec:**
```bash
traecli
> Generate an OpenAPI specification for this API
```

### Technical Documentation

**Project Overview:**
```bash
traecli
> Create a technical overview document for this project
```

**Architecture Documentation:**
```bash
traecli
> Create detailed architecture documentation
```

**Setup Guide:**
```bash
traecli
> Generate a setup and installation guide
```

### Code Documentation

**Generate Code Comments:**
```bash
traecli
> Add comprehensive comments to the authentication module
```

**Generate JSDoc:**
```bash
traecli
> Generate JSDoc comments for the utility functions
```

**Generate README:**
```bash
traecli
> Generate a comprehensive README.md for this project
```

## Code Refactoring

### Refactor Suggestions

**General Refactoring:**
```bash
traecli
> Suggest refactoring improvements for the data processing module
```

**Code Simplification:**
```bash
traecli
> Simplify the complex logic in the validation module
```

**Extract Functions:**
```bash
traecli
> Extract reusable functions from the large utility class
```

### Code Modernization

**Update to Modern Syntax:**
```bash
traecli
> Update this code to use modern JavaScript/TypeScript features
```

**Migrate to New Framework:**
```bash
traecli
> Migrate this Express.js code to Fastify
```

**Replace Deprecated APIs:**
```bash
traecli
> Replace deprecated APIs with current alternatives
```

## Bug Diagnosis

### Find Bugs

**General Bug Search:**
```bash
traecli
> Find potential bugs in the payment processing code
```

**Specific Bug Types:**
```bash
traecli
> Find race conditions in the concurrent processing code
```

**Edge Case Analysis:**
```bash
traecli
> Identify edge cases that might cause errors in the input validation
```

### Debug Issues

**Explain Error:**
```bash
traecli
> Explain why this authentication error is occurring: [paste error message]
```

**Trace Execution:**
```bash
traecli
> Trace the execution flow of the user registration process
```

**Identify Root Cause:**
```bash
traecli
> Identify the root cause of the memory leak in the image processing module
```

## Testing

### Generate Tests

**Unit Tests:**
```bash
traecli
> Generate unit tests for the authentication service
```

**Integration Tests:**
```bash
traecli
> Generate integration tests for the payment flow
```

**Test Cases:**
```bash
traecli
> Generate test cases for the input validation function
```

### Test Coverage

**Analyze Coverage:**
```bash
traecli
> Analyze the test coverage and identify gaps
```

**Suggest Improvements:**
```bash
traecli
> Suggest improvements to increase test coverage
```

**Generate Missing Tests:**
```bash
traecli
> Generate tests for uncovered code paths
```

## Migration

### Database Migration

**Generate Migration Script:**
```bash
traecli
> Generate a database migration script to add user preferences
```

**Analyze Impact:**
```bash
traecli
> Analyze the impact of the schema changes on existing data
```

**Rollback Plan:**
```bash
traecli
> Create a rollback plan for the database migration
```

### API Migration

**Version Migration:**
```bash
traecli
> Migrate API v1 endpoints to v2
```

**Breaking Changes:**
```bash
traecli
> Identify breaking changes in the new API version
```

**Migration Guide:**
```bash
traecli
> Generate a migration guide for API consumers
```

## Advanced Usage

### Batch Processing

**Process Multiple Files:**
```bash
traecli << EOF
Review src/auth.ts
Review src/user.ts
Review src/session.ts
EOF
```

**Generate Multiple Documents:**
```bash
traecli << EOF
Generate API documentation
Generate architecture overview
Generate setup guide
EOF
```

### Context-Aware Analysis

**Analyze with Context:**
```bash
cd /path/to/project
traecli
> Analyze the authentication system in the context of the overall architecture
```

**Compare with Context:**
```bash
traecli
> Compare the authentication implementation with industry best practices
```

### Streaming Output

**Monitor Progress:**
```bash
traecli
> Generate comprehensive documentation for the entire project
# Watch streaming output in real-time
```

**Large Tasks:**
```bash
traecli
> Analyze the entire codebase for security vulnerabilities
# Progress will be shown as analysis proceeds
```

## Integration Examples

### With Shell Scripts

**Automated Analysis:**
```bash
#!/bin/bash
# analyze-project.sh

echo "Analyzing project..."
traecli --non-interactive << EOF > analysis.md
Analyze the architecture of this project
Focus on scalability and maintainability
EOF

echo "Analysis complete. See analysis.md"
```

**CI/CD Integration:**
```bash
#!/bin/bash
# ci-review.sh

echo "Running code review..."
traecli --non-interactive << EOF > review.md
Review the recent changes
Focus on security and performance
EOF

# Check review results
if grep -q "critical" review.md; then
    echo "Critical issues found. Failing build."
    exit 1
fi
```

### With Python

**Programmatic Usage:**
```python
from scripts.execute import execute_task

# Execute task
result = execute_task("Analyze the authentication system")
print(result)

# Execute with context
context = {
    "project_path": "/path/to/project",
    "files": ["src/auth.ts", "src/user.ts"]
}
result = execute_task("Review the code", context)
print(result)
```

**Streaming Output:**
```python
from scripts.execute import execute_with_streaming

def handle_output(line):
    print(f"Output: {line}")

execute_with_streaming("Generate documentation", handle_output)
```

### With Node.js

**Execute Task:**
```javascript
const { exec } = require('child_process');

function executeTraeTask(prompt) {
    return new Promise((resolve, reject) => {
        const process = exec('traecli --non-interactive', (error, stdout, stderr) => {
            if (error) {
                reject(error);
            } else {
                resolve(stdout);
            }
        });
        
        process.stdin.write(JSON.stringify({ prompt }) + '\n');
        process.stdin.end();
    });
}

executeTraeTask('Analyze the architecture')
    .then(result => console.log(result))
    .catch(error => console.error(error));
```

## Real-World Scenarios

### Scenario 1: Onboarding New Developer

**Task:** Help new developer understand the project

```bash
traecli
> Generate an onboarding guide for new developers
> Explain the project architecture
> List the key components and their responsibilities
> Provide examples of common tasks
```

### Scenario 2: Security Audit

**Task:** Perform comprehensive security review

```bash
traecli
> Perform a security audit of the authentication system
> Check for SQL injection vulnerabilities
> Verify proper input validation
> Review session management
> Check for XSS vulnerabilities
```

### Scenario 3: Performance Optimization

**Task:** Optimize slow API endpoints

```bash
traecli
> Analyze the performance of the API endpoints
> Identify the slowest endpoints
> Suggest database query optimizations
> Recommend caching strategies
> Propose code-level optimizations
```

### Scenario 4: Legacy Code Migration

**Task:** Migrate legacy code to modern stack

```bash
traecli
> Analyze the legacy code structure
> Identify components to migrate
> Generate migration plan
> Create modern implementation examples
> Document breaking changes
```

### Scenario 5: Documentation Update

**Task:** Update outdated documentation

```bash
traecli
> Compare the code with existing documentation
> Identify outdated sections
> Generate updated documentation
> Add missing examples
> Clarify ambiguous descriptions
```

## Tips and Best Practices

### Effective Prompts

**Be Specific:**
```bash
# Good
traecli "Analyze the JWT token validation in src/auth/jwt.ts"

# Bad
traecli "Analyze the code"
```

**Provide Context:**
```bash
# Good
traecli "Review the authentication code focusing on security vulnerabilities"

# Bad
traecli "Review the code"
```

**Ask Follow-up Questions:**
```bash
# First question
traecli "Analyze the architecture"

# Follow-up
traecli "Explain how the authentication service communicates with the user service"
```

### Working with Large Projects

**Analyze in Parts:**
```bash
# Analyze by module
traecli "Analyze the authentication module"
traecli "Analyze the user management module"
traecli "Analyze the data processing module"
```

**Focus on Specific Areas:**
```bash
# Focus on security
traecli "Analyze the security implementation across all modules"

# Focus on performance
traecli "Analyze the performance characteristics of the API layer"
```

### Iterative Refinement

**Start Broad, Then Narrow:**
```bash
# Start with high-level analysis
traecli "Analyze the project architecture"

# Then dive deeper
traecli "Explain the authentication flow in detail"

# Then focus on specific issues
traecli "Identify potential security issues in the JWT implementation"
```

**Validate Suggestions:**
```bash
# Get suggestions
traecli "Suggest refactoring improvements for the data module"

# Then ask for justification
traecli "Explain why these refactoring suggestions are beneficial"

# Then ask for implementation details
traecli "Show me how to implement the first refactoring suggestion"
```

## Additional Resources

- [TRAE CLI API Reference](api.md)
- [Troubleshooting Guide](troubleshooting.md)
- [TRAE CLI Documentation](https://docs.trae.cn/cli/get-started-with-trae-cli)
- [OpenClaw Skills Documentation](https://docs.openclaw.ai/cli/skills)
