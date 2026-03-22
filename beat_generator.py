from flask import Flask, render_template, jsonify
from supabase import create_client
import threading, time, json, ollama

# ------------------------------
# Supabase Setup
# ------------------------------
SUPABASE_URL = "https://aarsjmnfmcjrrjwrvzvo.supabase.co"
SUPABASE_KEY = "sb_publishable_rKde5rs2TL49QvEoPjfSWQ_MsbPO6XG"
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# ------------------------------
# Flask Setup
# ------------------------------
app = Flask(__name__, template_folder="templates")

# ------------------------------
# Mood Frequency Mapping
# ------------------------------
DETAILED_MOOD_FREQ = {
    "happy_celebratory": [600, 650, 700],
    "happy_romantic": [620, 670, 720],
    "happy_content": [550, 580, 600],
    "angry_frustrated": [400, 420, 450],
    "angry_rage": [450, 480, 500],
    "angry_annoyed": [380, 400, 420],
    "sad_lonely": [200, 210, 220],
    "sad_disappointed": [180, 190, 200],
    "sad_nostalgic": [150, 170, 180],
    "neutral": [300]
}

def get_primary_mood(mood_text):
    return mood_text if mood_text in DETAILED_MOOD_FREQ else "neutral"

# ------------------------------
# Flask Routes
# ------------------------------
@app.route("/")
def home():
    return render_template("beat_index.html")

@app.route("/latest-beats", methods=["GET"])
def latest_beats():
    try:
        data = supabase.table("beats").select("*").order("created_at", desc=True).limit(1).execute()
        return jsonify(data.data if data.data else [])
    except:
        return jsonify([])

# ------------------------------
# Real-time Processing Thread
# ------------------------------
def process_new_messages():
    last_id = 0
    while True:
        try:
            messages = (
                supabase.table("messages")
                .select("*")
                .gt("id", last_id)
                .order("id", desc=False)
                .execute()
                .data
            )
            for msg in messages:
                text = msg.get("content", "")
                if not text:
                    continue

                # LLaMA2 Deep Mood Analysis
                prompt = f"""
                Analyze the mood and sentiment of this message in detailed categories.
                Return a JSON with keys: 'mood' and 'sentiment'.
                Example moods: happy_celebratory, happy_romantic, sad_lonely, angry_rage, etc.
                Message: {text}
                """
                response = ollama.chat(
                    model="llama2",
                    messages=[{"role": "user", "content": prompt}]
                )

                try:
                    analysis = json.loads(response["message"]["content"])
                    mood = get_primary_mood(analysis.get("mood", "neutral"))
                    sentiment = float(analysis.get("sentiment", 0))
                except:
                    mood = "neutral"
                    sentiment = 0

                frequencies = DETAILED_MOOD_FREQ[mood]

                # Save to beats table
                supabase.table("beats").insert({
                    "user_id": msg.get("user_id"),
                    "role": msg.get("role"),
                    "content": text,
                    "sentiment": sentiment,
                    "mood": mood,
                    "frequency_sequence": frequencies
                }).execute()

                last_id = msg["id"]

        except Exception as e:
            print("Error:", e)
        time.sleep(1)

# ------------------------------
# Start Thread + Flask Server
# ------------------------------
if __name__ == "__main__":
    t = threading.Thread(target=process_new_messages, daemon=True)
    t.start()
    # Bind host to 127.0.0.1 and port 6000
    app.run(host="127.0.0.1", port=6000, debug=True)