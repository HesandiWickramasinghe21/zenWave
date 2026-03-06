from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from ai_logic import analyze_sentiment, get_chatbot_response

app = FastAPI()

# IMPORTANT: This allows your Flutter app to talk to the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class UserMessage(BaseModel):
    text: str

@app.post("/chat")
async def chat_endpoint(message: UserMessage):
    # 1. Detect emotion 
    emotion = analyze_sentiment(message.text)
    
    # 2. Get AI response 
    reply = get_chatbot_response(message.text, emotion)
    
    # 3. Return results to Flutter
    return {
        "reply": reply,
        "emotion": emotion # This will eventually map to sound therapy [cite: 42]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

