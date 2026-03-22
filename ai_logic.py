\"\"\"AI and sentiment analysis logic.\"\"\"`nimport os
\"\"\"AI and sentiment analysis logic.\"\"\"`nimport requests
\"\"\"AI and sentiment analysis logic.\"\"\"`nfrom config import Config
\"\"\"AI and sentiment analysis logic.\"\"\"`n
\"\"\"AI and sentiment analysis logic.\"\"\"`nHF_TOKEN = Config.HF_TOKEN
\"\"\"AI and sentiment analysis logic.\"\"\"`nAPI_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
\"\"\"AI and sentiment analysis logic.\"\"\"`n
\"\"\"AI and sentiment analysis logic.\"\"\"`ndef analyze_sentiment(text: str) -> str:
\"\"\"AI and sentiment analysis logic.\"\"\"`n    text = text.lower()
\"\"\"AI and sentiment analysis logic.\"\"\"`n    if any(k in text for k in ["hurt", "die", "help", "kill"]): return "CRISIS"
\"\"\"AI and sentiment analysis logic.\"\"\"`n    if any(k in text for k in ["happy", "great", "good", "amazing"]): return "JOY"
\"\"\"AI and sentiment analysis logic.\"\"\"`n    if any(k in text for k in ["sad", "tired", "stressed", "overwhelmed"]): return "STRESSED"
\"\"\"AI and sentiment analysis logic.\"\"\"`n    return "NEUTRAL"
\"\"\"AI and sentiment analysis logic.\"\"\"`n
\"\"\"AI and sentiment analysis logic.\"\"\"`ndef get_chatbot_response(text: str, emotion: str) -> str:
\"\"\"AI and sentiment analysis logic.\"\"\"`n    return f"I understand you feel {emotion}. How can I support you?"
