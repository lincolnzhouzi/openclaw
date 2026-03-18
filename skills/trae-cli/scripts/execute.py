#!/usr/bin/env python3
"""
Execute TRAE CLI tasks
Handles task execution, output streaming, and error handling
"""

import subprocess
import json
import sys
from typing import Optional, Callable, Dict, Any
from pathlib import Path


class TraeCLIError(Exception):
    """Base exception for TRAE CLI errors"""
    pass


class InstallationError(TraeCLIError):
    """TRAE CLI not installed error"""
    pass


class AuthenticationError(TraeCLIError):
    """Authentication error"""
    pass


class ExecutionError(TraeCLIError):
    """Task execution error"""
    pass


class NetworkError(TraeCLIError):
    """Network error"""
    pass


def find_traecli() -> str:
    """
    Find TRAE CLI executable
    
    Returns:
        Path to TRAE CLI executable
        
    Raises:
        InstallationError: If TRAE CLI is not found
    """
    # Check common locations
    possible_paths = [
        Path.home() / ".local" / "bin" / "traecli",
        Path.home() / ".traecli" / "traecli",
        Path("/usr/local/bin/traecli"),
        Path("/usr/bin/traecli"),
    ]
    
    for path in possible_paths:
        if path.exists():
            return str(path)
    
    # Check PATH
    try:
        result = subprocess.run(
            ["which", "traecli"],
            capture_output=True,
            text=True,
            check=False
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except FileNotFoundError:
        pass
    
    # Check Windows
    if sys.platform == "win32":
        try:
            result = subprocess.run(
                ["where", "traecli"],
                capture_output=True,
                text=True,
                check=False
            )
            if result.returncode == 0:
                return result.stdout.strip().split('\n')[0]
        except FileNotFoundError:
            pass
    
    raise InstallationError("TRAE CLI not found. Please install it first.")


def execute_task(
    prompt: str,
    context: Optional[Dict[str, Any]] = None,
    timeout: int = 300
) -> str:
    """
    Execute a TRAE CLI task
    
    Args:
        prompt: Natural language prompt for the task
        context: Optional context information (project path, files, etc.)
        timeout: Maximum execution time in seconds (default: 300)
        
    Returns:
        Task execution result as string
        
    Raises:
        InstallationError: If TRAE CLI is not installed
        ExecutionError: If task execution fails
    """
    try:
        traecli = find_traecli()
    except InstallationError as e:
        raise InstallationError(str(e))
    
    # Prepare input
    input_data = {
        "prompt": prompt,
        "context": context or {}
    }
    
    try:
        # Execute TRAE CLI
        process = subprocess.Popen(
            [traecli],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1
        )
        
        # Send input
        process.stdin.write(json.dumps(input_data) + "\n")
        process.stdin.flush()
        
        # Wait for completion with timeout
        try:
            stdout, stderr = process.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            process.kill()
            stdout, stderr = process.communicate()
            raise ExecutionError(f"Task timed out after {timeout} seconds")
        
        # Check for errors
        if process.returncode != 0:
            error_msg = stderr.strip() if stderr.strip() else "Unknown error"
            
            # Check for specific error types
            if "authentication" in error_msg.lower() or "not authenticated" in error_msg.lower():
                raise AuthenticationError(f"Authentication failed: {error_msg}")
            elif "network" in error_msg.lower() or "connection" in error_msg.lower():
                raise NetworkError(f"Network error: {error_msg}")
            else:
                raise ExecutionError(f"Task execution failed: {error_msg}")
        
        return stdout.strip()
    
    except FileNotFoundError:
        raise InstallationError("TRAE CLI executable not found")
    except Exception as e:
        if isinstance(e, TraeCLIError):
            raise
        raise ExecutionError(f"Unexpected error: {e}")


def execute_with_streaming(
    prompt: str,
    callback: Callable[[str], None],
    context: Optional[Dict[str, Any]] = None,
    timeout: int = 300
):
    """
    Execute a TRAE CLI task with streaming output
    
    Args:
        prompt: Natural language prompt for the task
        callback: Callback function to handle each line of output
        context: Optional context information
        timeout: Maximum execution time in seconds (default: 300)
        
    Raises:
        InstallationError: If TRAE CLI is not installed
        ExecutionError: If task execution fails
    """
    try:
        traecli = find_traecli()
    except InstallationError as e:
        raise InstallationError(str(e))
    
    # Prepare input
    input_data = {
        "prompt": prompt,
        "context": context or {}
    }
    
    try:
        # Execute TRAE CLI
        process = subprocess.Popen(
            [traecli],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1
        )
        
        # Send input
        process.stdin.write(json.dumps(input_data) + "\n")
        process.stdin.flush()
        process.stdin.close()
        
        # Stream output
        try:
            for line in process.stdout:
                if line.strip():
                    callback(line.rstrip('\n'))
            
            # Wait for process to complete
            process.wait(timeout=timeout)
            
            if process.returncode != 0:
                raise ExecutionError(f"Task failed with exit code {process.returncode}")
        
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
            raise ExecutionError(f"Task timed out after {timeout} seconds")
    
    except FileNotFoundError:
        raise InstallationError("TRAE CLI executable not found")
    except Exception as e:
        if isinstance(e, TraeCLIError):
            raise
        raise ExecutionError(f"Unexpected error: {e}")


def execute_with_retry(
    prompt: str,
    max_retries: int = 3,
    context: Optional[Dict[str, Any]] = None,
    timeout: int = 300
) -> str:
    """
    Execute a TRAE CLI task with automatic retry
    
    Args:
        prompt: Natural language prompt for the task
        max_retries: Maximum number of retry attempts (default: 3)
        context: Optional context information
        timeout: Maximum execution time in seconds (default: 300)
        
    Returns:
        Task execution result as string
        
    Raises:
        TraeCLIError: If all retries fail
    """
    import time
    
    last_error = None
    
    for attempt in range(max_retries):
        try:
            return execute_task(prompt, context, timeout)
        except AuthenticationError as e:
            # Authentication error - don't retry
            raise
        except NetworkError as e:
            # Network error - retry with exponential backoff
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                print(f"Network error, retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                time.sleep(wait_time)
                last_error = e
            else:
                raise
        except ExecutionError as e:
            # Execution error - don't retry
            raise
        except Exception as e:
            # Unexpected error - retry
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                print(f"Unexpected error, retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                time.sleep(wait_time)
                last_error = e
            else:
                raise
    
    raise TraeCLIError(f"Failed after {max_retries} retries: {last_error}")


if __name__ == "__main__":
    # Test execution
    print("TRAE CLI Execution Test")
    print("=" * 50)
    
    try:
        # Simple task
        result = execute_task("Say hello")
        print(f"Result: {result}")
        
        # Streaming task
        print("\nStreaming test:")
        def print_line(line):
            print(f"  {line}")
        
        execute_with_streaming("Count to 5", print_line)
        
    except TraeCLIError as e:
        print(f"Error: {e}")
        sys.exit(1)
