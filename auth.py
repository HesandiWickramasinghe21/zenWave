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


