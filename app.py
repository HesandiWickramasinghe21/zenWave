from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime

# 1. Initialize the Flask App
app = Flask(__name__)
CORS(app)  # This allows your Flutter app to connect to this server



# 3. Home Route (To check if backend is alive)
@app.route('/')
def home():
    return "ZenWave Mood Backend is Active!"

# 4. Save Mood Route (The POST method for your project)
@app.route('/add_mood', methods=['POST'])
def add_mood():
    try:
        data = request.json
        
        # Structure the data for the database
        new_entry = {
            "user_id": data.get("user_id"),   # From Auth student
            "mood_label": data.get("mood"),  # e.g., "Happy"
            "mood_score": data.get("score"), # e.g., 5
            "note": data.get("note", ""),    # Optional text
            "timestamp": datetime.now()      # Automatic time
        }
        
        result = mood_collection.insert_one(new_entry)
        return jsonify({
            "status": "success", 
            "message": "Mood recorded!",
            "id": str(result.inserted_id)
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400



# 6. Run the server
if __name__ == '__main__':
    app.run(debug=True, port=5000)