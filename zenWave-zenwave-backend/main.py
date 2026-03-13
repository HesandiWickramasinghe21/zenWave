from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

from db import SessionLocal, Base, engine
from models import User, Journal, JournalEntryRequest
from auth import hash_password, verify_password, create_token, decode_token
import sentiment_logic 

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

class SignUpRequest(BaseModel):
    full_name: Optional[str] = None
    email: str
    phone: Optional[str] = None
    gender: Optional[str] = None
    birthday: Optional[str] = None
    password: str

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

# Temporary in-memory storage for non-DB journaling
# Note: This will reset when the server restarts
in_memory_journals = []

# Schema for the journal input
class SimpleJournalRequest(BaseModel):
    title: str
    content: str

@app.post("/journal/create-simple")
def create_simple_journal(payload: SimpleJournalRequest, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """
    Option 1: Create Journal
    Receives text and saves it to an in-memory list.
    """
    token = credentials.credentials
    email = decode_token(token) # Ensures the user is logged in [cite: 31, 78]
    
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
    """
    Option 2: Saved Journal Entry
    Displays all entries saved by the current logged-in user.
    """
    token = credentials.credentials
    email = decode_token(token)
    
    # Filter the list to only show entries belonging to the current user
    user_entries = [j for j in in_memory_journals if j["user_email"] == email]
    
    return {"saved_entries": user_entries}