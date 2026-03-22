from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

from db import SessionLocal, Base, engine
from models import User
from auth import hash_password, verify_password, create_token, decode_token

app = FastAPI(title="ZenWave backend", description="Mental Wellness Support API")

@app.get("/")
def read_root():
    return {"status": "ok", "message": "ZenWave API is running"}


# ---------- CORS ----------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] # TODO: Restrict in production,  # Flutter Web / Mobile ok
    allow_credentials=True,
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests  
from ai_logic import analyze_sentiment, get_chatbot_response

app = FastAPI()

# IMPORTANT: This allows your Flutter app to talk to the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()

# Create DB tables (first run / after DB delete)
Base.metadata.create_all(bind=engine)

# ---------- DB ----------
from typing import Generator

def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------- Request Models ----------
class SignUpRequest(BaseModel):
    full_name: str | None = None
    email: EmailStr
    phone: str | None = None
    gender: str | None = None
    birthday: str | None = None
    password: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    new_password: str

# ---------- Sign Up (Register new user) ----------
@app.post("/signup", tags=["Authentication"], status_code=201)
def signin(payload: SignUpRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if user:
        raise HTTPException(status_code=400, detail="User already exists")

    new_user = User(
        email=payload.email,
        password=hash_password(payload.password),
        full_name=payload.full_name,
        phone=payload.phone,
        gender=payload.gender,
        birthday=payload.birthday,
    )
    db.add(new_user)
    db.commit()
    return {"message": "Account created successfully"}

# ---------- Login ----------
@app.post("/login", tags=["Authentication"])
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if not user or not verify_password(payload.password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials", headers={"WWW-Authenticate": "Bearer"})

    token = create_token(user.email)
    return {"access_token": token, "token_type": "bearer"}

# ---------- Protected Route ----------
@app.get("/profile", tags=["User Profile"])
def profile(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
):
    token = credentials.credentials
    email = decode_token(token)
    if not email:
        raise HTTPException(status_code=401, detail="Invalid token")

    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return {
        "message": f"Welcome {user.email}",
        "user": {
            "email": user.email,
            "full_name": user.full_name,
            "phone": user.phone,
            "gender": user.gender,
            "birthday": user.birthday,
        },
    }

# ---------- Forgot Password (check email exists) ----------
@app.post("/forgot-password", tags=["Password Management"])
def forgot_password(payload: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # For project: just confirm email exists
    return {"message": "Email verified. You can reset password."}

# ---------- Reset Password (update new password) ----------
@app.post("/reset-password", tags=["Password Management"])
def reset_password(payload: ResetPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.password = hash_password(payload.new_password)
    db.commit()

    return {"message": "Password updated successfully"}
# The URL of your teammate's Flask server
MOOD_DB_URL = "http://127.0.0.1:5000/add_mood"

class UserMessage(BaseModel):
    text: str
    user_id: str = "student_user_1" 

@app.post("/chat")
async def chat_endpoint(message: UserMessage):
    emotion = analyze_sentiment(message.text)
    reply = get_chatbot_response(message.text, emotion)
    
    # Use real, accessible MP3 links for testing the player
    sound_library = {
        "JOY": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", 
        "STRESSED": "https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3", # Calming Nature
        "CRISIS": "https://cdn.pixabay.com/download/audio/2021/11/25/audio_91b106e572.mp3", # Gentle Piano
        "NEUTRAL": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"
    }

    # IMPORTANT: Your Flutter app must look for "recommended_sound" in the JSON
    return {
        "reply": reply,
        "emotion": emotion,
        "recommended_sound": sound_library.get(emotion, sound_library["NEUTRAL"])
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
