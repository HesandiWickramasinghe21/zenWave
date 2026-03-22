import os
import requests
from config import Config

HF_TOKEN = Config.HF_TOKEN

def analyze_sentiment(text: str) -> str:
    if not text:
        return "NEUTRAL"
    text = text.lower()
    if any(k in text for k in ["sad", "bad", "cry", "hopeless"]):
        return "STRESSED"
    if any(k in text for k in ["happy", "great", "good", "love", "amazing"]):
        return "JOY"
    if any(k in text for k in ["help", "hurt", "die", "kill"]):
        return "CRISIS"
    return "NEUTRAL"

def get_chatbot_response(text: str, emotion: str) -> str:
    return f"I understand you are feeling {emotion}. I am here to support you. How can I help?"
