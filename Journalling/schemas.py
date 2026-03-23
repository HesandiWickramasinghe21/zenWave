from pydantic import BaseModel
from datetime import datetime
from typing import Optional

# This is what the user sends to create a journal entry
class JournalCreate(BaseModel):
    title: str
    content: str
    mood: Optional[str] = None  # e.g., "Anxious", "Calm" [cite: 51]

# This is what the API returns (includes ID and timestamp)
class JournalEntry(JournalCreate):
    id: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True