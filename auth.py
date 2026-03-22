from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext
from utils import setup_logger

logger = setup_logger(__name__)

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

def register_user(email: str, password: str):
    # Registration logic placeholder
    return {"message": "User registered"}

def login_user(email: str, password: str):
    # Login logic placeholder
    return {"access_token": "fake_token", "token_type": "bearer"}

def logout_user():
    # Logout logic placeholder
    return {"message": "Logged out successfully"}
