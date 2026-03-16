# ZenWave Authentication Module - Supabase Auth Integration
# Handles user authentication, registration, and session management

import os
from dotenv import load_dotenv
from supabase import create_client, Client
from typing import Optional, Dict, Any

# Load environment variables
load_dotenv()

# Supabase Configuration
SUPABASE_URL = os.getenv("SUPABASE_URL", "https://aarsjmnfmcjrrjwrvzvo.supabase.co")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

# Initialize Supabase client for authentication
_auth_client: Client = None


def get_auth_client() -> Client:
    """
    Get or create the Supabase authentication client.
    Uses singleton pattern for efficient resource usage.
    
    Returns:
        Client: Supabase client instance
    """
    global _auth_client
    if _auth_client is None:
        if not SUPABASE_KEY:
            raise ValueError("SUPABASE_KEY must be set in environment variables")
        _auth_client = create_client(SUPABASE_URL, SUPABASE_KEY)
    return _auth_client


# ============================================================
# User Registration and Login Functions
# ============================================================

def register_user(email: str, password: str) -> Dict[str, Any]:
    """
    Register a new user with email and password.
    
    Args:
        email: User's email address
        password: User's chosen password
    
    Returns:
        dict: Response containing user data or error information
    """
    client = get_auth_client()
    try:
        response = client.auth.sign_up({
            "email": email,
            "password": password
        })
        return {"success": True, "user": response.user, "session": response.session}
    except Exception as e:
        return {"success": False, "error": str(e)}


def login_user(email: str, password: str) -> Dict[str, Any]:
    """
    Authenticate a user with email and password credentials.
    
    Args:
        email: User's email address
        password: User's password
    
    Returns:
        dict: Response containing session data or error information
    """
    client = get_auth_client()
    try:
        response = client.auth.sign_in_with_password({
            "email": email,
            "password": password
        })
        return {"success": True, "user": response.user, "session": response.session}
    except Exception as e:
        return {"success": False, "error": str(e)}


