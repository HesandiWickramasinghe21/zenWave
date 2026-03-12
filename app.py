from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime

# 1. Initialize the Flask App
app = Flask(__name__)
CORS(app)  # This allows your Flutter app to connect to this server

# 2. Database Connection
# Note: Replace 'localhost' with the URI your teammate provides later
try:
    client = MongoClient("mongodb://localhost:27017/")
    db = client['zenwave_db']
    mood_collection = db['mood_history']
    print("Connected to MongoDB successfully!")
except Exception as e:
    print(f"Database connection error: {e}")

# 3. Home Route (To check if backend is alive)
@app.route('/')
def home():
    return "ZenWave Mood Backend is Active!"

# 4. Save Mood Route (The POST method for your project)
@app.route('/add_mood', methods=['POST'])
def add_mood():
    try:
        data = request.json
        
        
        
        result = mood_collection.insert_one(new_entry)
        return jsonify({
            "status": "success", 
            "message": "Mood recorded!",
            "id": str(result.inserted_id)
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# 5. Get History Route (The GET method for your charts)
@app.route('/get_history/<user_id>', methods=['GET'])
def get_history(user_id):
    try:
        # Find last 10 entries for a specific user
        cursor = mood_collection.find({"user_id": user_id}).sort("timestamp", -1).limit(10)
        
        history = []
        for entry in cursor:
            history.append({
                "mood": entry["mood_label"],
                "score": entry["mood_score"],
                "date": entry["timestamp"].strftime("%Y-%m-%d %H:%M")
            })
            
        return jsonify(history), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 6. Run the server
if __name__ == '__main__':
    app.run(debug=True, port=5000)