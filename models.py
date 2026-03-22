from pydantic import BaseModel

class UserMessage(BaseModel):
    text: str
    user_id: str = "user_1"
    session_id: str = "session_1"

class ChatResponse(BaseModel):
    reply: str
    emotion: str
    recommended_sound: str

class HealthResponse(BaseModel):
    status: str
