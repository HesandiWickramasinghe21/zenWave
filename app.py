from flask import Flask, request, jsonify, render_template
import ollama
from flask_cors import CORS
from supabase import create_client
import uuid

# ------------------------------
# Supabase Setup
# ------------------------------
SUPABASE_URL = "https://aarsjmnfmcjrrjwrvzvo.supabase.co" 
SUPABASE_KEY = "sb_publishable_rKde5rs2TL49QvEoPjfSWQ_MsbPO6XG" 
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

app = Flask(__name__)
CORS(app)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/chat", methods=["POST"])
def chat():
    data = request.json
    user_message = data.get("message")
    user_id = data.get("user_id")

    if not user_id:
        user_id = str(uuid.uuid4())

    # 1. Save user message
    supabase.table("messages").insert({
        "user_id": user_id,
        "role": "user",
        "content": user_message
    }).execute()

    # 2. FETCH HISTORY
    history_data = supabase.table("messages") \
        .select("role", "content") \
        .eq("user_id", user_id) \
        .order("created_at", desc=True) \
        .limit(10) \
        .execute()

    history = history_data.data[::-1]

    # 3. UPDATED System Prompt
    messages_for_ai = [
        {
            "role": "system", 
            "content": (
                "You are ZenWave, Umaya's friendly peer from Sri Lanka. "
                "STRICT PROTOCOL: "
                "1. If Umaya is just chatting, be casual and stay under 15 words. "
                "2. If Umaya asks for help or breathing, say ONLY: 'I suggest the [Exercise Name] session below. 🌿' "
                "3. Use Umaya's name often. "
                "4. MANDATORY: You MUST end every single message with the word MOOD: followed by one category. "
                "Example: 'I'm here for you, Umaya. MOOD: STRESSED'"
            )
        }
    ]
    
    for msg in history:
        messages_for_ai.append({"role": msg["role"], "content": msg["content"]})

    # 4. Get AI response
    response = ollama.chat(model="llama2", messages=messages_for_ai)
    full_reply = response['message']['content']

    # 5. Robust Emotion and BPM Logic
    full_reply_upper = full_reply.upper()
    
    if "STRESSED" in full_reply_upper:
        detected_emotion = "STRESSED"
        bpm_val = 98
    elif "ANXIOUS" in full_reply_upper:
        detected_emotion = "ANXIOUS"
        bpm_val = 105
    elif "SAD" in full_reply_upper:
        detected_emotion = "SAD"
        bpm_val = 62
    elif "JOY" in full_reply_upper:
        detected_emotion = "JOY"
        bpm_val = 68
    elif "ANGRY" in full_reply_upper:
        detected_emotion = "ANGRY"
        bpm_val = 115
    else:
        detected_emotion = "NEUTRAL"
        bpm_val = 72

    # Clean the reply for the user
    clean_reply = full_reply.split("MOOD:")[0].strip()

    # 6. Save AI's response
    supabase.table("messages").insert({
        "user_id": user_id,
        "role": "assistant",
        "content": clean_reply
    }).execute()

    return jsonify({
        "reply": clean_reply,
        "user_id": user_id,
        "emotion": detected_emotion,
        "bpm": bpm_val
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)