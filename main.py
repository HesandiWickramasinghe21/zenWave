from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import UserMessage, ChatResponse, HealthResponse
from ai_logic import analyze_sentiment, get_chatbot_response
from database import save_user_mood, log_sound_recommendation
from auth import register_user, login_user, logout_user
from constants import SOUND_LIBRARY, DEFAULT_HOST, DEFAULT_PORT
from utils import setup_logger

logger = setup_logger(__name__)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/register")`nasync def register(email: str, password: str):`n    return register_user(email, password)`n`n@app.post("/login")`nasync def login(email: str, password: str):`n    return login_user(email, password)`n`n@app.post("/logout")`nasync def logout():`n    return logout_user()`n`n@app.get("/mood/history/{user_id}")`nasync def history(user_id: str):`n    from database import get_user_mood_history; return get_user_mood_history(user_id)`n`n@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok")

@app.post("/chat", response_model=ChatResponse)
async def chat(message: UserMessage):
    emotion = analyze_sentiment(message.text)
    try:
        save_user_mood(message.user_id, emotion, message.text)
        log_sound_recommendation(message.user_id, emotion, sound_url)
    except Exception as e:
        logger.error(f"Failed to log mood or sound: {e}")
    return ChatResponse(reply=reply, emotion=emotion, recommended_sound=sound_url)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=DEFAULT_HOST, port=DEFAULT_PORT)
