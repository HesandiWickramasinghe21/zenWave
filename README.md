# ZenWave - Mental Health Support Application

ZenWave is an AI-powered mental health support application that provides
empathetic chatbot responses, mood tracking, and therapeutic sound
recommendations.

## Features

- **AI Chatbot**: Empathetic conversational AI powered by HuggingFace
- **Mood Detection**: Automatic sentiment analysis (JOY, STRESSED, CRISIS, NEUTRAL)
- **Sound Therapy**: Mood-based therapeutic audio recommendations
- **Mood History**: Track emotional patterns over time
- **User Authentication**: Secure registration and login via Supabase

## Tech Stack

- **Backend**: FastAPI (Python)
- **Database**: Supabase (PostgreSQL)
- **AI Model**: HuggingFace BlenderBot 400M
- **Auth**: Supabase Auth

## Setup

1. Clone the repository
2. Copy `.env.example` to `.env` and fill in your credentials
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the server:
   ```bash
   python main.py
   ```

## API Endpoints

| Method | Endpoint                  | Description                |
|--------|---------------------------|----------------------------|
| GET    | `/health`                 | Health check               |
| POST   | `/chat`                   | Send a chat message        |
| POST   | `/register`               | Register a new user        |
| POST   | `/login`                  | Login                      |
| POST   | `/logout`                 | Logout                     |
| GET    | `/mood/history/{user_id}` | Get mood history           |
| GET    | `/mood/stats/{user_id}`   | Get mood statistics        |

## Project Structure

```
├── main.py           # FastAPI application entry point
├── ai_logic.py       # Sentiment analysis and chatbot logic
├── database.py       # Supabase database operations
├── auth.py           # Authentication module
├── models.py         # Pydantic data models
├── config.py         # Centralized configuration
├── constants.py      # Application constants
├── utils.py          # Utility functions
├── test_ai_logic.py  # AI logic unit tests
├── test_models.py    # Model unit tests
└── requirements.txt  # Python dependencies
```
