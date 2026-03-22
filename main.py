from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# Team's Database & Logic Files
from db import SessionLocal, Base, engine
from models import User, Journal, JournalEntryRequest
from auth import hash_password, verify_password, create_token, decode_token
import sentiment_logic 

# Chatbot Dependencies
import ollama
from supabase import create_client
import uuid

app = FastAPI()

# 🛑 ALLOW WEB ACCESS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- SCHEMAS (Group + Chatbot) ---

class SignUpRequest(BaseModel):
    full_name: Optional[str] = None
    email: str
    phone: Optional[str] = None
    gender: Optional[str] = None
    birthday: Optional[str] = None
    password: str

class SimpleJournalRequest(BaseModel):
    title: str
    content: str

class ChatRequest(BaseModel):
    message: str
    user_id: Optional[str] = None

# --- GROUP AUTH ENDPOINTS ---

@app.post("/signup")
def signup(payload: SignUpRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email.strip().lower()).first()
    if user:
        raise HTTPException(status_code=400, detail="User already exists")
    new_user = User(
        email=payload.email.strip().lower(),
        password=hash_password(payload.password),
        full_name=payload.full_name,
        phone=payload.phone,
        gender=payload.gender,
        birthday=payload.birthday,
    )
    db.add(new_user)
    db.commit()
    return {"message": "Account created successfully"}

@app.post("/login")
def login(payload: dict, db: Session = Depends(get_db)):
    email = payload.get("email", "").strip().lower()
    user = db.query(User).filter(User.email == email).first()
    if not user or not verify_password(payload.get("password", ""), user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_token(user.email)
    return {"access_token": token, "token_type": "bearer"}

@app.get("/profile")
def profile(credentials: HTTPAuthorizationCredentials = Depends(security), db: Session = Depends(get_db)):
    token = credentials.credentials
    email = decode_token(token)
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {
        "full_name": user.full_name or "Gopithan",
        "email": user.email,
        "gender": user.gender or "male",
        "phone": user.phone,
        "birthday": user.birthday,
    }

# --- GROUP JOURNALING ENDPOINTS ---

in_memory_journals = []

@app.post("/journal/create-simple")
def create_simple_journal(payload: SimpleJournalRequest, credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    email = decode_token(token) 
    
    entry = {
        "user_email": email,
        "title": payload.title,
        "content": payload.content,
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
    
    in_memory_journals.append(entry)
    return {"message": "Journal saved successfully", "entry": entry}

@app.get("/journal/saved-entries")
def get_saved_journals(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    email = decode_token(token)
    
    user_entries = [j for j in in_memory_journals if j["user_email"] == email]
    
    return {"saved_entries": user_entries}

# --- CHATBOT SYSTEM CONFIG ---

SUPABASE_URL = "https://aarsjmnfmcjrrjwrvzvo.supabase.co"
SUPABASE_KEY = "sb_publishable_rKde5rs2TL49QvEoPjfSWQ_MsbPO6XG"
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

@app.post("/chat")
def chat(request: ChatRequest):
    user_message = request.message
    user_id = request.user_id

    if not user_id or user_id == "string":
        user_id = str(uuid.uuid4())

    # 1. Save user message to Supabase
    supabase.table("messages").insert({
        "user_id": user_id,
        "role": "user",
        "content": user_message
    }).execute()

    # 2. Fetch History for Context
    history_data = supabase.table("messages") \
        .select("role", "content") \
        .eq("user_id", user_id) \
        .order("created_at", desc=True) \
        .limit(10) \
        .execute()

    history = history_data.data[::-1]

    # 3. System Prompt (Umaya Protocol)
    messages_for_ai = [
        {
            "role": "system",
            "content": (
                "You are ZenWave, Umaya's friendly peer from Sri Lanka. "
                "STRICT PROTOCOL: "
                "1. If Umaya is just chatting, be casual and stay under 15 words. "
                "2. If Umaya asks for help or breathing, say ONLY: 'I suggest the [Exercise Name] session below. 🌿' "
                "3. Use Umaya's name often. "
                "4. MANDATORY: You MUST end every single message with the word MOOD: followed by one category. "
                "Example: 'I'm here for you, Umaya. MOOD: STRESSED'"
            )
        }
    ]

    for msg in history:
        messages_for_ai.append({"role": msg["role"], "content": msg["content"]})

    # 4. Get AI Response via Ollama
    response = ollama.chat(model="llama2", messages=messages_for_ai)
    full_reply = response['message']['content']

    # 5. Emotion & BPM Logic
    full_reply_upper = full_reply.upper()
    
    if "STRESSED" in full_reply_upper:
        detected_emotion, bpm_val = "STRESSED", 98
    elif "ANXIOUS" in full_reply_upper:
        detected_emotion, bpm_val = "ANXIOUS", 105
    elif "SAD" in full_reply_upper:
        detected_emotion, bpm_val = "SAD", 62
    elif "JOY" in full_reply_upper:
        detected_emotion, bpm_val = "JOY", 68
    elif "ANGRY" in full_reply_upper:
        detected_emotion, bpm_val = "ANGRY", 115
    else:
        detected_emotion, bpm_val = "NEUTRAL", 72

    # Clean the reply for the UI (Remove the MOOD tag)
    clean_reply = full_reply.split("MOOD:")[0].strip()

    # 6. Save AI Response
    supabase.table("messages").insert({
        "user_id": user_id,
        "role": "assistant",
        "content": clean_reply
    }).execute()

    return {
        "reply": clean_reply,
        "user_id": user_id,
        "emotion": detected_emotion,
        "bpm": bpm_val
    }