"""Authentication utilities including JWT and password hashing."""
from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext

import os
SECRET_KEY = os.getenv("SECRET_KEY", "mysecret123")
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
# ZenWave Authentication Module - Supabase Auth Integration
# Handles user authentication, registration, and session management

import os
from dotenv import load_dotenv
from supabase import create_client, Client
from typing import Optional, Dict, Any

# Load environment variables
load_dotenv()

# Supabase Configuration
SUPABASE_URL = os.getenv("SUPABASE_URL", "https://aarsjmnfmcjrrjwrvzvo.supabase.co")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

# Initialize Supabase client for authentication
_auth_client: Client = None


def get_auth_client() -> Client:
    """
    Get or create the Supabase authentication client.
    Uses singleton pattern for efficient resource usage.
    
    Returns:
        Client: Supabase client instance
    """
    global _auth_client
    if _auth_client is None:
        if not SUPABASE_KEY:
            raise ValueError("SUPABASE_KEY must be set in environment variables")
        _auth_client = create_client(SUPABASE_URL, SUPABASE_KEY)
    return _auth_client


# ============================================================
# User Registration and Login Functions
# ============================================================

def register_user(email: str, password: str) -> Dict[str, Any]:
    """
    Register a new user with email and password.
    
    Args:
        email: User's email address
        password: User's chosen password
    
    Returns:
        dict: Response containing user data or error information
    """
    client = get_auth_client()
    try:
        response = client.auth.sign_up({
            "email": email,
            "password": password
        })
        return {"success": True, "user": response.user, "session": response.session}
    except Exception as e:
        return {"success": False, "error": str(e)}


def login_user(email: str, password: str) -> Dict[str, Any]:
    """
    Authenticate a user with email and password credentials.
    
    Args:
        email: User's email address
        password: User's password
    
    Returns:
        dict: Response containing session data or error information
    """
    client = get_auth_client()
    try:
        response = client.auth.sign_in_with_password({
            "email": email,
            "password": password
        })
        return {"success": True, "user": response.user, "session": response.session}
    except Exception as e:
        return {"success": False, "error": str(e)}


def logout_user() -> Dict[str, Any]:
    """
    Sign out the currently authenticated user.
    
    Returns:
        dict: Response indicating logout success or failure
    """
    client = get_auth_client()
    try:
        client.auth.sign_out()
        return {"success": True, "message": "User logged out successfully"}
    except Exception as e:
        return {"success": False, "error": str(e)}


# ============================================================
# Session Validation Functions
# ============================================================

def get_current_user() -> Optional[Dict[str, Any]]:
    """
    Retrieve the currently authenticated user's information.
    
    Returns:
        dict or None: Current user data if authenticated, None otherwise
    """
    client = get_auth_client()
    try:
        user = client.auth.get_user()
        if user:
            return {"id": user.user.id, "email": user.user.email}
        return None
    except Exception:
        return None


def validate_session(access_token: str) -> bool:
    """
    Validate if a given access token is still valid.
    
    Args:
        access_token: JWT access token to validate
    
    Returns:
        bool: True if token is valid, False otherwise
    """
    client = get_auth_client()
    try:
        user = client.auth.get_user(access_token)
        return user is not None
    except Exception:
        return False


# ============================================================
# Password Reset Functions  
# ============================================================

def request_password_reset(email: str) -> Dict[str, Any]:
    """
    Send a password reset email to the specified address.
    
    Args:
        email: Email address to send reset link to
    
    Returns:
        dict: Response indicating if email was sent successfully
    """
    client = get_auth_client()
    try:
        client.auth.reset_password_email(email)
        return {"success": True, "message": "Password reset email sent"}
    except Exception as e:
        return {"success": False, "error": str(e)}


def update_user_password(new_password: str) -> Dict[str, Any]:
    """
    Update the password for the currently authenticated user.
    
    Args:
        new_password: The new password to set
    
    Returns:
        dict: Response indicating password update success or failure
    """
    client = get_auth_client()
    try:
        client.auth.update_user({"password": new_password})
        return {"success": True, "message": "Password updated successfully"}
    except Exception as e:
        return {"success": False, "error": str(e)}
