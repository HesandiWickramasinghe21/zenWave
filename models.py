"""SQLAlchemy models representing database tables."""
from sqlalchemy import Column, Integer, String, DateTime
import datetime
from db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    email = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)

    full_name = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    birthday = Column(String, nullable=True)  # "YYYY-MM-DD"
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
