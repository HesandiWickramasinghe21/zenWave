import os
import requests
import time
from dotenv import load_dotenv

load_dotenv()

HF_TOKEN = os.getenv("HF_TOKEN")
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
headers = {"Authorization": f"Bearer {HF_TOKEN}"}

def analyze_sentiment(text):
    text_lower = text.lower()
    
    # Crisis Check
    if any(word in text_lower for word in ["hurt", "die", "kill", "suicide", "help"]):
        return "CRISIS"
    
    # Enhanced Keywords for your specific tests
    if any(w in text_lower for w in ["happy", "good", "great", "joy", "proud"]): 
        return "JOY"
    if any(w in text_lower for w in ["sad", "sick", "overwhelmed", "stress", "hard", "rest", "tired"]): 
        return "STRESSED"
    
    return "NEUTRAL"

def get_chatbot_response(text, emotion):
    # Professional Greeting Handler
    text_clean = text.lower().strip()
    greetings = ["hi", "hello", "hey", "hola", "good morning", "good evening"]
    
    if text_clean in greetings:
        return "Hello! I'm ZenWave, your personal space for calm. How is your heart feeling today?"

    if emotion == "CRISIS":
        return "I'm concerned. Please reach out to a professional or a crisis hotline immediately. Your safety is my priority."

    # Existing AI Logic with Retries
    for attempt in range(3):
        try:
            # We add a 'personality' hint to the input
            prompt = f"As a calm mental health assistant, reply to: {text}"
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt}, timeout=10)
            output = response.json()
            
            if isinstance(output, dict) and "estimated_time" in output:
                time.sleep(2)
                continue
                
            if isinstance(output, list) and len(output) > 0:
                full_reply = output[0].get('generated_text', "")
                # Remove the prompt from the AI response if it appears
                return full_reply.replace(prompt, "").strip() or "I hear you. Tell me more."
            
            if isinstance(output, dict) and 'generated_text' in output:
                return output['generated_text']

        except Exception as e:
            return f"Backend Error: {str(e)}"
            
    return "I'm here for you. It sounds like you've had a lot on your mind lately."

