from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext
import os
from supabase import create_client, Client
from utils import setup_logger

logger = setup_logger(__name__)

# Supabase Configuration - Ensure that Supabase credentials are kept securely in the environment.

SECRET_KEY = "mysecret123"
ALGORITHM = "HS256"
EXPIRE_MINUTES = 60

pwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")

def hash_password(password: str):
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str):
    return pwd_context.verify(plain, hashed)

def create_token(email: str):
    payload = {
        "sub": email,
        "exp": datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload.get("sub")
    except JWTError:
        return None
