# ZenWave Database Module - Supabase Integration
# This module handles all database operations for the ZenWave mental health application

import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables from .env file
load_dotenv()

# Supabase Configuration - Using environment variables for security
SUPABASE_URL = os.getenv("SUPABASE_URL", "https://aarsjmnfmcjrrjwrvzvo.supabase.co")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

# Initialize Supabase client
supabase: Client = None

def init_supabase() -> Client:
    """
    Initialize and return the Supabase client connection.
    This function ensures a singleton pattern for the database connection.
    """
    global supabase
    if supabase is None:
        if not SUPABASE_KEY:
            raise ValueError("SUPABASE_KEY environment variable is not set")
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    return supabase


# ============================================================
