from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests  # Import this to talk to the other backend
from ai_logic import analyze_sentiment, get_chatbot_response

app = FastAPI()

# IMPORTANT: This allows your Flutter app to talk to the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# The URL of your teammate's Flask server
MOOD_DB_URL = "http://127.0.0.1:5000/add_mood"

class UserMessage(BaseModel):
    text: str
    user_id: str = "student_user_1" # Added a default user_id for the database

@app.post("/chat")
async def chat_endpoint(message: UserMessage):
    # 1. Detect emotion 
    emotion = analyze_sentiment(message.text)
    
    # 2. Get AI response 
    reply = get_chatbot_response(message.text, emotion)
    
    # 3. NEW: Send data to the Mood History Backend (Commit 17 Logic)
    try:
        # We calculate a score based on the emotion
        score_map = {"JOY": 5, "NEUTRAL": 3, "STRESSED": 1, "CRISIS": 0}
        
        payload = {
            "user_id": message.user_id,
            "mood": emotion,
            "score": score_map.get(emotion, 3),
            "note": message.text[:50] # Save the first 50 characters as a note
        }
        
        # This sends the data to the Flask server (Port 5000)
        requests.post(MOOD_DB_URL, json=payload, timeout=2)
        print(f"Successfully logged {emotion} to Mood Database")
        
    except Exception as e:
        print(f"Failed to connect to Mood Backend: {e}")
    
    # 4. Return results to Flutter
    return {
        "reply": reply,
        "emotion": emotion
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)