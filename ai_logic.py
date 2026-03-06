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
    if emotion == "CRISIS":
        return "I'm concerned. Please reach out to a professional or a crisis hotline immediately."

    # Try up to 3 times in case the model is still loading
    for attempt in range(3):
        try:
            response = requests.post(API_URL, headers=headers, json={"inputs": text}, timeout=10)
            output = response.json()
            
            # If model is loading, wait and try again
            if isinstance(output, dict) and "estimated_time" in output:
                time.sleep(2)
                continue
                
            if isinstance(output, list) and len(output) > 0:
                return output[0].get('generated_text', "I'm listening.")
            
            if isinstance(output, dict) and 'generated_text' in output:
                return output['generated_text']

        except Exception as e:
        # This will tell us if it's a timeout, a bad token, or something else
        return f"Backend Error: {str(e)}"
        