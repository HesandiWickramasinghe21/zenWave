\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom fastapi import FastAPI, Depends, HTTPException
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom fastapi.middleware.cors import CORSMiddleware
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom models import UserMessage, ChatResponse, HealthResponse
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom ai_logic import analyze_sentiment, get_chatbot_response
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom database import save_user_mood, log_sound_recommendation, get_user_mood_history, get_mood_statistics
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom auth import register_user, login_user, logout_user
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom constants import SOUND_LIBRARY, DEFAULT_HOST, DEFAULT_PORT
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nfrom utils import setup_logger
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nlogger = setup_logger(__name__)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`napp = FastAPI(title="ZenWave AI", version="1.0.1")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`napp.add_middleware(
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    CORSMiddleware,
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    allow_origins=["*"],
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    allow_credentials=True,
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    allow_methods=["*"],
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    allow_headers=["*"],
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.get("/health", response_model=HealthResponse)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def health():
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return HealthResponse(status="ok")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.post("/register")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def register(email: str, password: str):
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return register_user(email, password)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.post("/login")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def login(email: str, password: str):
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return login_user(email, password)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.post("/logout")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def logout():
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return logout_user()
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.get("/mood/history/{user_id}")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def history(user_id: str):
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return get_user_mood_history(user_id)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.get("/mood/stats/{user_id}")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def stats(user_id: str):
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return get_mood_statistics(user_id)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n@app.post("/chat", response_model=ChatResponse)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nasync def chat(message: UserMessage):
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    emotion = analyze_sentiment(message.text)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    sound_url = SOUND_LIBRARY.get(emotion, SOUND_LIBRARY["NEUTRAL"])
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    try:
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n        save_user_mood(message.user_id, emotion, message.text)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n        log_sound_recommendation(message.user_id, emotion, sound_url)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    except Exception as e:
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n        logger.error(f"Failed to log mood or sound: {e}")
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    reply = get_chatbot_response(message.text, emotion)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    return ChatResponse(reply=reply, emotion=emotion, recommended_sound=sound_url)
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`nif __name__ == "__main__":
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    import uvicorn
\"\"\"ZenWave Main API Gateway: Handles routing and application logic.\"\"\"`n    uvicorn.run(app, host=DEFAULT_HOST, port=8000)
