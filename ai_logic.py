import os
import requests
import time
import random
from typing import List
from dotenv import load_dotenv

load_dotenv()

# Configuration
HF_TOKEN = os.getenv("HF_TOKEN")
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
headers = {"Authorization": f"Bearer {HF_TOKEN}"}

# Global memory to store conversation context
conversation_history: List[str] = []

def analyze_sentiment(text: str) -> str:
    """
    Analyzes user input to categorize the emotional state.
    Returns: 'CRISIS', 'JOY', 'STRESSED', or 'NEUTRAL'.
    """
    text_lower = text.lower()
    
    # Priority 1: Safety/Crisis detection
    if any(word in text_lower for word in ["hurt", "die", "kill", "suicide", "help"]):
        return "CRISIS"
    
    # Priority 2: Positive reinforcement detection
    if any(w in text_lower for w in ["happy", "good", "great", "joy", "proud", "amazing", "excited", "love", "wonderful"]): 
        return "JOY"
    
    # Priority 3: Stress and negative emotion detection
    if any(w in text_lower for w in ["sad", "sick", "overwhelmed", "stress", "hard", "tired", "lonely", "anxious", "angry", "exhausted"]): 
        return "STRESSED"
    
    return "NEUTRAL"

def get_chatbot_response(text: str, emotion: str) -> str:
    global conversation_history
    
    # 1. Store history
    conversation_history.append(f"User: {text}")
    if len(conversation_history) > 6:
        conversation_history.pop(0)

    context_string = "\n".join(conversation_history)

    # 2. PROMPT ENGINEERING: Tell the AI the detected emotion
    # This makes the AI "think" and analyze the mood specifically
    prompt = (
        f"System: You are ZenWave, a deeply empathetic mental health counselor. "
        f"The user is currently feeling {emotion}. "
        f"Conversation History:\n{context_string}\n"
        f"ZenWave: [Respond with deep empathy and ask a helpful question]"
    )

    for attempt in range(3):
        try:
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt}, timeout=10)
            output = response.json()
            
            if isinstance(output, list) and len(output) > 0:
                full_reply = output[0].get('generated_text', "")
                # Clean up the AI reply
                clean_reply = full_reply.split("ZenWave:")[-1].strip()
                return clean_reply
        except Exception as e:
            continue
            
    return "I'm processing what you've shared. I'm here to listen—please tell me more."
