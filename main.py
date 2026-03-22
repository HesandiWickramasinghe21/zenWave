# Entry point for the ZenWave FastAPI application.
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from ai_logic import analyze_sentiment, get_chatbot_response
from database import save_user_mood, log_sound_recommendation
from utils import setup_logger

logger = setup_logger(__name__)

app = FastAPI()

# IMPORTANT: This allows your Flutter app to talk to the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# The URL of your teammate's Flask server
MOOD_DB_URL = "http://127.0.0.1:5000/add_mood"

class UserMessage(BaseModel):
    text: str
    user_id: str = "student_user_1"
    session_id: str = "default_session"

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.post("/chat")
async def chat_endpoint(message: UserMessage):
    """Process a chat message, evaluate emotion, and return response."""
    emotion = analyze_sentiment(message.text)
    reply = get_chatbot_response(message.text, emotion)
    
    # Use real, accessible MP3 links for testing the player
    sound_library = {
        "JOY": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", 
        "STRESSED": "https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3", # Calming Nature
        "CRISIS": "https://cdn.pixabay.com/download/audio/2021/11/25/audio_91b106e572.mp3", # Gentle Piano
        "NEUTRAL": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"
    }

    sound = sound_library.get(emotion, sound_library["NEUTRAL"])
    try:
        save_user_mood(message.user_id, emotion, message.text)
        log_sound_recommendation(message.user_id, emotion, sound)
    except Exception as e:
        logger.error(f"Database error: {e}")

    # IMPORTANT: Your Flutter app must look for "recommended_sound" in the JSON
    return {
        "reply": reply,
        "emotion": emotion,
        "recommended_sound": sound
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)