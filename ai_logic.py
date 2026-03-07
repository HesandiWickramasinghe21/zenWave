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
    \"\"\"
    Analyzes user input to categorize the emotional state.
    Returns: 'CRISIS', 'JOY', 'STRESSED', or 'NEUTRAL'.
    \"\"\"
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
    \"\"\"
    Generates a contextual response using a hybrid of 
    rule-based empathy and AI-generated dialogue.
    \"\"\"
    global conversation_history
    text_clean = text.lower().strip()
    
    # --- Layer 1: Rule-Based Fast Response ---
    greetings = ["hi", "hello", "hey", "hola", "good morning", "good evening"]
    if text_clean in greetings:
        return random.choice([
            "Hello! I'm ZenWave, your personal space for calm. How is your heart feeling today?",
            "Hi there! I'm ZenWave. I'm here to listen—what's on your mind?",
            "Welcome back. How has your energy been today?"
        ])

    # --- Layer 2: Emotional Intelligence Layer ---
    if emotion == "STRESSED":
        return "I can feel that things are heavy for you right now. I'm right here with you—take a deep breath."
    
    if emotion == "JOY":
        return "That is wonderful! I love hearing that. What's the best part of this feeling for you?"

    # --- Layer 3: AI Contextual Dialogue ---
    conversation_history.append(f"User: {text}")
    
    # Maintain sliding window of 4 messages for context stability
    if len(conversation_history) > 4:
        conversation_history.pop(0)

    context_string = "\n".join(conversation_history)

    for attempt in range(3):
        try:
            prompt = f"Context: You are ZenWave, an empathetic wellness bot. History:\n{context_string}\nZenWave:"
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt}, timeout=10)
            output = response.json()
            
            # Handle model loading time
            if isinstance(output, dict) and "estimated_time" in output:
                time.sleep(2)
                continue
                
            if isinstance(output, list) and len(output) > 0:
                full_reply = output[0].get('generated_text', "")
                clean_reply = full_reply.split("ZenWave:")[-1].strip()
                
                final_text = clean_reply if clean_reply else "I'm listening. Tell me more."
                conversation_history.append(f"ZenWave: {final_text}")
                return final_text
            
        except Exception as e:
            return f"Service currently unavailable: {str(e)}"
            
    return "I'm here for you. Tell me more about what you're experiencing."