import os
import requests
import time
import random
from dotenv import load_dotenv

load_dotenv()

HF_TOKEN = os.getenv("HF_TOKEN")
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
headers = {"Authorization": f"Bearer {HF_TOKEN}"}

# --- NEW: Conversation Memory ---
# This list stores the last few messages so the AI stays on track
conversation_history = []

def analyze_sentiment(text):
    text_lower = text.lower()
    
    if any(word in text_lower for word in ["hurt", "die", "kill", "suicide", "help"]):
        return "CRISIS"
    
    if any(w in text_lower for w in ["happy", "good", "great", "joy", "proud", "amazing", "excited", "love", "wonderful"]): 
        return "JOY"
    
    if any(w in text_lower for w in ["sad", "sick", "overwhelmed", "stress", "hard", "tired", "lonely", "anxious", "angry", "exhausted"]): 
        return "STRESSED"
    
    return "NEUTRAL"

def get_chatbot_response(text, emotion):
    global conversation_history
    text_clean = text.lower().strip()
    
    # 1. Handle Greetings (Fast response)
    greetings = ["hi", "hello", "hey", "hola", "good morning", "good evening"]
    if text_clean in greetings:
        replies = [
            "Hello! I'm ZenWave, your personal space for calm. How is your heart feeling today?",
            "Hi there! I'm ZenWave. I'm here to listen—what's on your mind?",
            "Welcome back. How has your energy been today?"
        ]
        return random.choice(replies)

    # 2. Emotional Support Layer
    if emotion == "STRESSED":
        return "I can feel that things are heavy for you right now. I'm right here with you—take a deep breath."
    
    if emotion == "JOY":
        return "That is wonderful! I love hearing that. What's the best part of this feeling for you?"

    # 3. AI Memory Logic (Commit 17)
    # Add the current user message to the memory
    conversation_history.append(f"User: {text}")
    
    # Keep only the last 4 messages to prevent the AI from getting confused
    if len(conversation_history) > 4:
        conversation_history.pop(0)

    # Combine memory into a single prompt for the AI
    context_string = "\n".join(conversation_history)

    # 4. AI API Call with Context
    for attempt in range(3):
        try:
            # We send the history so the AI knows what was said before
            prompt = f"Context: You are ZenWave, an empathetic wellness bot. History:\n{context_string}\nZenWave:"
            
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt}, timeout=10)
            output = response.json()
            
            if isinstance(output, dict) and "estimated_time" in output:
                time.sleep(2)
                continue
                
            if isinstance(output, list) and len(output) > 0:
                full_reply = output[0].get('generated_text', "")
                clean_reply = full_reply.split("ZenWave:")[-1].strip()
                
                final_text = clean_reply if clean_reply else "I'm listening. Tell me more."
                
                # Add the AI's response to memory too
                conversation_history.append(f"ZenWave: {final_text}")
                return final_text
            
        except Exception as e:
            return f"Backend Error: {str(e)}"
            
    return "I'm here for you. Tell me more about what you're experiencing."