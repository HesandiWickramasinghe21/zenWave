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
