#!/usr/bin/env python3
"""
Configuration Manager for TRAE CLI
Handles configuration loading, saving, and validation
"""

import json
import os
from typing import Optional, Dict, Any
from pathlib import Path


class ConfigManager:
    """Manages TRAE CLI configuration"""
    
    DEFAULT_CONFIG = {
        "version": "1.0.0",
        "traecli": {
            "path": None,
            "version": None,
            "auto_update": True,
            "timeout": 300
        },
        "session": {
            "enabled": True,
            "timeout": 3600,
            "persist": True
        },
        "output": {
            "format": "markdown",
            "streaming": True,
            "verbose": False
        }
    }
    
    def __init__(self, config_path: Optional[str] = None):
        """
        Initialize configuration manager
        
        Args:
            config_path: Path to configuration file. Defaults to ~/.openclaw/trae-cli/config.json
        """
        if config_path is None:
            home = Path.home()
            config_path = home / ".openclaw" / "trae-cli" / "config.json"
        
        self.config_path = Path(config_path)
        self.config = self.load_config()
    
    def load_config(self) -> Dict[str, Any]:
        """
        Load configuration from file
        
        Returns:
            Configuration dictionary
        """
        if self.config_path.exists():
            try:
                with open(self.config_path, 'r', encoding='utf-8') as f:
                    loaded_config = json.load(f)
                    # Merge with defaults to ensure all keys exist
                    return self._merge_configs(self.DEFAULT_CONFIG, loaded_config)
            except (json.JSONDecodeError, IOError) as e:
                print(f"Warning: Failed to load config: {e}")
                return self.DEFAULT_CONFIG.copy()
        
        return self.DEFAULT_CONFIG.copy()
    
    def save_config(self):
        """Save configuration to file"""
        try:
            self.config_path.parent.mkdir(parents=True, exist_ok=True)
            with open(self.config_path, 'w', encoding='utf-8') as f:
                json.dump(self.config, f, indent=2, ensure_ascii=False)
        except IOError as e:
            raise IOError(f"Failed to save config: {e}")
    
    def get(self, key: str, default: Any = None) -> Any:
        """
        Get configuration value by key (supports dot notation)
        
        Args:
            key: Configuration key (e.g., "traecli.timeout")
            default: Default value if key not found
            
        Returns:
            Configuration value or default
        """
        keys = key.split('.')
        value = self.config
        
        for k in keys:
            if isinstance(value, dict) and k in value:
                value = value[k]
            else:
                return default
        
        return value
    
    def set(self, key: str, value: Any):
        """
        Set configuration value by key (supports dot notation)
        
        Args:
            key: Configuration key (e.g., "traecli.timeout")
            value: Value to set
        """
        keys = key.split('.')
        config = self.config
        
        for k in keys[:-1]:
            if k not in config:
                config[k] = {}
            config = config[k]
        
        config[keys[-1]] = value
        self.save_config()
    
    def reset(self):
        """Reset configuration to defaults"""
        self.config = self.DEFAULT_CONFIG.copy()
        self.save_config()
    
    def get_all(self) -> Dict[str, Any]:
        """
        Get all configuration
        
        Returns:
            Complete configuration dictionary
        """
        return self.config.copy()
    
    def _merge_configs(self, default: Dict[str, Any], loaded: Dict[str, Any]) -> Dict[str, Any]:
        """
        Merge loaded config with defaults
        
        Args:
            default: Default configuration
            loaded: Loaded configuration
            
        Returns:
            Merged configuration
        """
        result = default.copy()
        
        for key, value in loaded.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = self._merge_configs(result[key], value)
            else:
                result[key] = value
        
        return result
    
    def validate(self) -> bool:
        """
        Validate configuration
        
        Returns:
            True if configuration is valid, False otherwise
        """
        # Check required keys
        required_keys = [
            "traecli.timeout",
            "session.timeout",
            "output.format"
        ]
        
        for key in required_keys:
            if self.get(key) is None:
                return False
        
        # Validate timeout values
        traecli_timeout = self.get("traecli.timeout")
        if not isinstance(traecli_timeout, int) or traecli_timeout <= 0:
            return False
        
        session_timeout = self.get("session.timeout")
        if not isinstance(session_timeout, int) or session_timeout <= 0:
            return False
        
        # Validate output format
        output_format = self.get("output.format")
        if output_format not in ["markdown", "json", "text"]:
            return False
        
        return True


if __name__ == "__main__":
    # Test configuration manager
    print("Configuration Manager Test")
    print("=" * 50)
    
    manager = ConfigManager()
    
    # Get configuration
    print("Current configuration:")
    print(json.dumps(manager.get_all(), indent=2))
    
    # Get specific values
    print(f"\nTRAE CLI timeout: {manager.get('traecli.timeout')}")
    print(f"Output format: {manager.get('output.format')}")
    
    # Set configuration
    print("\nSetting tracli.timeout to 600...")
    manager.set("traecli.timeout", 600)
    print(f"New value: {manager.get('traecli.timeout')}")
    
    # Validate configuration
    print(f"\nConfiguration valid: {manager.validate()}")
    
    # Reset configuration
    print("\nResetting configuration...")
    manager.reset()
    print(f"TRAE CLI timeout after reset: {manager.get('traecli.timeout')}")
