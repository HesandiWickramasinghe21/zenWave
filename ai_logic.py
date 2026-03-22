import os
import requests
from config import Config

HF_TOKEN = Config.HF_TOKEN
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"

def analyze_sentiment(text: str) -> str:
    text = text.lower()
    if any(k in text for k in ["hurt", "die", "help", "kill"]): return "CRISIS"
    if any(k in text for k in ["happy", "great", "good", "amazing"]): return "JOY"
    if any(k in text for k in ["sad", "tired", "stressed", "overwhelmed"]): return "STRESSED"
    return "NEUTRAL"

def get_chatbot_response(text: str, emotion: str) -> str:
    return f"I understand you feel {emotion}. How can I support you?"
