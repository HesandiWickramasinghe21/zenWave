"""
ZenWave Constants
Centralized constants used across the application.
"""

# Sound library mapping moods to therapeutic audio tracks
SOUND_LIBRARY = {
    "JOY": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    "STRESSED": "https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3",
    "CRISIS": "https://cdn.pixabay.com/download/audio/2021/11/25/audio_91b106e572.mp3",
    "NEUTRAL": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
}

# Supported mood categories
MOOD_CATEGORIES = ["JOY", "STRESSED", "CRISIS", "NEUTRAL"]

# API defaults
DEFAULT_HOST = "0.0.0.0"
DEFAULT_PORT = 8000
MAX_CONVERSATION_HISTORY = 6
