#!/usr/bin/env python3
"""
Session Manager for TRAE CLI
Handles authentication, session persistence, and session lifecycle
"""

import json
import os
import time
from typing import Optional, Dict, Any
from pathlib import Path


class SessionManager:
    """Manages TRAE CLI sessions"""
    
    def __init__(self, session_dir: Optional[str] = None):
        """
        Initialize session manager
        
        Args:
            session_dir: Directory to store session data. Defaults to ~/.openclaw/trae-cli/
        """
        if session_dir is None:
            home = Path.home()
            session_dir = home / ".openclaw" / "trae-cli"
        
        self.session_dir = Path(session_dir)
        self.session_file = self.session_dir / "session.json"
        self.auth_token_file = self.session_dir / "auth_token.json"
        self.config_file = self.session_dir / "config.json"
        
        # Ensure directories exist
        self.session_dir.mkdir(parents=True, exist_ok=True)
    
    def load_session(self) -> Dict[str, Any]:
        """
        Load session information from disk
        
        Returns:
            Dictionary containing session data, or empty dict if no session exists
        """
        if self.session_file.exists():
            try:
                with open(self.session_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except (json.JSONDecodeError, IOError) as e:
                print(f"Warning: Failed to load session: {e}")
                return {}
        return {}
    
    def save_session(self, session: Dict[str, Any]):
        """
        Save session information to disk
        
        Args:
            session: Dictionary containing session data
        """
        try:
            with open(self.session_file, 'w', encoding='utf-8') as f:
                json.dump(session, f, indent=2, ensure_ascii=False)
        except IOError as e:
            raise IOError(f"Failed to save session: {e}")
    
    def is_authenticated(self) -> bool:
        """
        Check if user is authenticated
        
        Returns:
            True if authenticated, False otherwise
        """
        session = self.load_session()
        
        # Check if authenticated flag is set
        if not session.get('authenticated', False):
            return False
        
        # Check if session has expired
        expires_at = session.get('expires_at')
        if expires_at and time.time() > expires_at:
            return False
        
        return True
    
    def get_auth_token(self) -> Optional[str]:
        """
        Get authentication token
        
        Returns:
            Authentication token string, or None if not available
        """
        if self.auth_token_file.exists():
            try:
                with open(self.auth_token_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data.get('token')
            except (json.JSONDecodeError, IOError):
                pass
        return None
    
    def save_auth_token(self, token: str, expires_in: int = 3600):
        """
        Save authentication token
        
        Args:
            token: Authentication token string
            expires_in: Token lifetime in seconds (default: 1 hour)
        """
        expires_at = time.time() + expires_in
        data = {
            'token': token,
            'expires_at': expires_at
        }
        
        try:
            with open(self.auth_token_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
        except IOError as e:
            raise IOError(f"Failed to save auth token: {e}")
    
    def create_session(self, user_id: str, session_id: str, expires_in: int = 3600):
        """
        Create a new session
        
        Args:
            user_id: User identifier
            session_id: Session identifier
            expires_in: Session lifetime in seconds (default: 1 hour)
        """
        session = {
            'authenticated': True,
            'user_id': user_id,
            'session_id': session_id,
            'created_at': time.time(),
            'expires_at': time.time() + expires_in
        }
        self.save_session(session)
    
    def clear_session(self):
        """Clear session data (logout)"""
        if self.session_file.exists():
            self.session_file.unlink()
        if self.auth_token_file.exists():
            self.auth_token_file.unlink()
    
    def refresh_session(self, expires_in: int = 3600):
        """
        Refresh session expiration time
        
        Args:
            expires_in: New session lifetime in seconds (default: 1 hour)
        """
        session = self.load_session()
        if session.get('authenticated'):
            session['expires_at'] = time.time() + expires_in
            self.save_session(session)
    
    def get_session_info(self) -> Dict[str, Any]:
        """
        Get session information
        
        Returns:
            Dictionary containing session details
        """
        session = self.load_session()
        return {
            'authenticated': session.get('authenticated', False),
            'user_id': session.get('user_id'),
            'session_id': session.get('session_id'),
            'created_at': session.get('created_at'),
            'expires_at': session.get('expires_at'),
            'is_expired': session.get('expires_at', 0) < time.time() if session.get('expires_at') else False
        }


if __name__ == "__main__":
    # Test the session manager
    manager = SessionManager()
    
    print("Session Manager Test")
    print("=" * 50)
    
    # Check authentication status
    print(f"Authenticated: {manager.is_authenticated()}")
    
    # Get session info
    info = manager.get_session_info()
    print(f"Session info: {json.dumps(info, indent=2)}")
    
    # Create a test session
    print("\nCreating test session...")
    manager.create_session("test_user", "test_session_123")
    print(f"Authenticated: {manager.is_authenticated()}")
    
    # Clear session
    print("\nClearing session...")
    manager.clear_session()
    print(f"Authenticated: {manager.is_authenticated()}")
