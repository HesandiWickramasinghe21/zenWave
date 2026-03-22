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

@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok")

@app.post("/chat", response_model=ChatResponse)
async def chat(message: UserMessage):
    emotion = analyze_sentiment(message.text)
    save_user_mood(message.user_id, emotion, message.text)
    reply = get_chatbot_response(message.text, emotion)
    sound_url = SOUND_LIBRARY.get(emotion, SOUND_LIBRARY["NEUTRAL"])
    log_sound_recommendation(message.user_id, emotion, sound_url)
    return ChatResponse(reply=reply, emotion=emotion, recommended_sound=sound_url)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=DEFAULT_HOST, port=DEFAULT_PORT)
