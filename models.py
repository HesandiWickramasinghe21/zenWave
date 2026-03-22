from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.sql import func
from pydantic import BaseModel
from db import Base

# --- DATABASE TABLES (SQLAlchemy) ---
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    full_name = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    birthday = Column(String, nullable=True)

class Journal(Base):
    __tablename__ = "journals"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))
    title = Column(String)
    content = Column(String)
    sentiment = Column(String)
    sound_profile = Column(String)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())

# --- REQUEST MODELS (Pydantic) ---
class JournalEntryRequest(BaseModel):
    title: str
    content: str