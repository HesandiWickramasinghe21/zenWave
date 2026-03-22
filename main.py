# Entry point for the ZenWave FastAPI application.
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from models import UserMessage, ChatResponse, HealthResponse
from ai_logic import analyze_sentiment, get_chatbot_response
from database import save_user_mood, log_sound_recommendation, get_user_mood_history, get_mood_statistics
from utils import setup_logger
from constants import SOUND_LIBRARY, DEFAULT_HOST, DEFAULT_PORT

logger = setup_logger(__name__)

app = FastAPI()

# IMPORTANT: This allows your Flutter app to talk to the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


from auth import register_user, login_user, logout_user

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.post("/register")
async def register_endpoint(email: str, password: str):
    """Register a new user account."""
    return register_user(email, password)

@app.post("/login")
async def login_endpoint(email: str, password: str):
    """Login an existing user."""
    return login_user(email, password)

@app.post("/logout")
async def logout_endpoint():
    """Logout the current user."""
    return logout_user()

@app.get("/mood/history/{user_id}")
async def mood_history_endpoint(user_id: str, limit: int = 10):
    """Get mood history for a user."""
    return get_user_mood_history(user_id, limit)

@app.get("/mood/stats/{user_id}")
async def mood_stats_endpoint(user_id: str):
    """Get mood statistics for a user."""
    return get_mood_statistics(user_id)
@app.post("/chat")
async def chat_endpoint(message: UserMessage):
    """Process a chat message, evaluate emotion, and return response."""
    emotion = analyze_sentiment(message.text)
    reply = get_chatbot_response(message.text, emotion)
    
    sound = SOUND_LIBRARY.get(emotion, SOUND_LIBRARY["NEUTRAL"])
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
    uvicorn.run(app, host=DEFAULT_HOST, port=DEFAULT_PORT)