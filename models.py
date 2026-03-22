"""
ZenWave Data Models
Pydantic models for request/response schemas.
"""
from pydantic import BaseModel
from typing import Optional


class UserMessage(BaseModel):
    """Schema for incoming chat messages from the Flutter app."""
    text: str
    user_id: str = "student_user_1"
    session_id: str = "default_session"


class ChatResponse(BaseModel):
    """Schema for the chat endpoint response."""
    reply: str
    emotion: str
    recommended_sound: str


class HealthResponse(BaseModel):
    """Schema for the health check endpoint response."""
    status: str
