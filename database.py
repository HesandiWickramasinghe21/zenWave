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
# User Mood Data Operations
# ============================================================

def save_user_mood(user_id: str, mood: str, message: str) -> dict:
    """
    Save a user's mood entry to the database.
    
    Args:
        user_id: Unique identifier for the user
        mood: Detected mood category (JOY, STRESSED, CRISIS, NEUTRAL)
        message: Original user message text
    
    Returns:
        dict: The inserted record data
    """
    client = init_supabase()
    data = {
        "user_id": user_id,
        "mood": mood,
        "message": message
    }
    result = client.table("mood_entries").insert(data).execute()
    return result.data


def get_user_mood_history(user_id: str, limit: int = 10) -> list:
    """
    Retrieve mood history for a specific user.
    
    Args:
        user_id: Unique identifier for the user
        limit: Maximum number of records to return (default: 10)
    
    Returns:
        list: List of mood entry records
    """
    client = init_supabase()
    result = client.table("mood_entries").select("*").eq("user_id", user_id).order("created_at", desc=True).limit(limit).execute()
    return result.data


def get_mood_statistics(user_id: str) -> dict:
    """
    Calculate mood statistics for a user.
    
    Args:
        user_id: Unique identifier for the user
    
    Returns:
        dict: Statistics including mood counts and percentages
    """
    client = init_supabase()
    result = client.table("mood_entries").select("mood").eq("user_id", user_id).execute()
    
    # Calculate mood distribution
    moods = [entry["mood"] for entry in result.data]
    total = len(moods)
    
    if total == 0:
        return {"total_entries": 0, "distribution": {}}
    
    distribution = {}
    for mood in ["JOY", "STRESSED", "CRISIS", "NEUTRAL"]:
        count = moods.count(mood)
        distribution[mood] = {
            "count": count,
            "percentage": round((count / total) * 100, 2)
        }
    
    return {"total_entries": total, "distribution": distribution}


# ============================================================
