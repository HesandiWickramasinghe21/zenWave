import os
import requests
import time
import random
from dotenv import load_dotenv

load_dotenv()

HF_TOKEN = os.getenv("HF_TOKEN")
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
headers = {"Authorization": f"Bearer {HF_TOKEN}"}

# --- NEW: Conversation Memory (Commit 17) ---
# This list stays in the server's RAM to remember the last few messages
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
    global conversation_history # Tell Python to use the memory list
    
    text_clean = text.lower().strip()
    
    # 1. Randomized Greetings
    greetings = ["hi", "hello", "hey", "hola", "good morning", "good evening"]
    if text_clean in greetings:
        replies = [
            "Hello! I'm ZenWave, your personal space for calm. How is your heart feeling today?",
            "Hi there! I'm ZenWave. I'm here to listen—what's on your mind?",
            "Welcome back. I'm ZenWave. How has your energy been today?"
        ]
        return random.choice(replies)

    # 2. Dynamic Empathy for Emotions
    if emotion == "STRESSED":
        st_replies = [
            "I can feel that things are heavy for you right now. It's okay to feel overwhelmed.",
            "That sounds like a lot to carry. I'm right here with you—take a deep breath.",
            "I hear how much pressure you're under. Let's take this one step at a time."
        ]
        return random.choice(st_replies)
    
    if emotion == "JOY":
        joy_replies = [
            "That is wonderful! It's so important to lean into these moments of light.",
            "I love hearing that! What's the best part of this feeling for you?",
            "That's amazing news. Thank you for sharing that spark of joy with me!"
        ]
        return random.choice(joy_replies)

    # 3. Memory Logic: Add current message to history
    conversation_history.append(f"User: {text}")
    
    # Keep history short (last 4 lines) so the AI doesn't get confused
    if len(conversation_history) > 4:
        conversation_history.pop(0)

    # Combine history into one block of text for the AI
    context_string = "\n".join(conversation_history)

    # 4. Enhanced AI Call with Context
    for attempt in range(3):
        try:
            # We send the history (context) instead of just the latest message
            prompt = f"Context: You are ZenWave, a highly empathetic wellness assistant. History:\n{context_string}\nZenWave:"
            
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt}, timeout=10)
            output = response.json()
            
            if isinstance(output, dict) and "estimated_time" in output:
                time.sleep(2)
                continue
                
            if isinstance(output, list) and len(output) > 0:
                full_reply = output[0].get('generated_text', "")
                clean_reply = full_reply.split("ZenWave:")[-1].strip()
                
                final_text = clean_reply if clean_reply else "I'm listening. Tell me more."
                
                # Add AI's own reply to its memory
                conversation_history.append(f"ZenWave: {final_text}")
                return final_text
            
        except Exception as e:
            return f"Backend Error: {str(e)}"
            
    return "I'm here for you. Tell me more about what you're experiencing."