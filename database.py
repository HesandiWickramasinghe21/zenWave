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

