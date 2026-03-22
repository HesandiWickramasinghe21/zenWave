from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import UserMessage, ChatResponse, HealthResponse
from ai_logic import analyze_sentiment, get_chatbot_response
from database import save_user_mood, log_sound_recommendation, get_user_mood_history, get_mood_statistics
from auth import register_user, login_user, logout_user
from constants import SOUND_LIBRARY, DEFAULT_HOST, DEFAULT_PORT
from utils import setup_logger

logger = setup_logger(__name__)

app = FastAPI(title="ZenWave AI", version="1.0.1")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok")

@app.post("/register")
async def register(email: str, password: str):
    return register_user(email, password)

@app.post("/login")
async def login(email: str, password: str):
    return login_user(email, password)

@app.post("/logout")
async def logout():
    return logout_user()

@app.get("/mood/history/{user_id}")
async def history(user_id: str):
    return get_user_mood_history(user_id)

@app.get("/mood/stats/{user_id}")
async def stats(user_id: str):
    return get_mood_statistics(user_id)

@app.post("/chat", response_model=ChatResponse)
async def chat(message: UserMessage):
    emotion = analyze_sentiment(message.text)
    sound_url = SOUND_LIBRARY.get(emotion, SOUND_LIBRARY["NEUTRAL"])
    try:
        save_user_mood(message.user_id, emotion, message.text)
        log_sound_recommendation(message.user_id, emotion, sound_url)
    except Exception as e:
        logger.error(f"Failed to log mood or sound: {e}")
    reply = get_chatbot_response(message.text, emotion)
    return ChatResponse(reply=reply, emotion=emotion, recommended_sound=sound_url)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=DEFAULT_HOST, port=8000)
