from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

from db import SessionLocal, Base, engine
from models import User
from auth import hash_password, verify_password, create_token, decode_token

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok", "message": "ZenWave API is running"}


# ---------- CORS ----------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Flutter Web / Mobile ok
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()

# Create DB tables (first run / after DB delete)
Base.metadata.create_all(bind=engine)

# ---------- DB ----------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------- Request Models ----------
class SignUpRequest(BaseModel):
    full_name: str | None = None
    email: str
    phone: str | None = None
    gender: str | None = None
    birthday: str | None = None
    password: str

class LoginRequest(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: str

class ResetPasswordRequest(BaseModel):
    email: str
    new_password: str

# ---------- Sign Up (Register new user) ----------
@app.post("/signup", tags=["Authentication"])
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
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token(user.email)
    return {"access_token": token, "token_type": "bearer"}

# ---------- Protected Route ----------
@app.get("/profile")
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
@app.post("/forgot-password")
def forgot_password(payload: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # For project: just confirm email exists
    return {"message": "Email verified. You can reset password."}

# ---------- Reset Password (update new password) ----------
@app.post("/reset-password")
def reset_password(payload: ResetPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == payload.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.password = hash_password(payload.new_password)
    db.commit()

    return {"message": "Password updated successfully"}
