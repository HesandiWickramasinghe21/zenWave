from fastapi import FastAPI, HTTPException
from typing import List
from datetime import datetime
from schemas import JournalCreate, JournalEntry

app = FastAPI(title="ZenWave Journaling API")

# Mock Database (Since your teammate is doing the real DB later)
# We use a list to store entries in memory for now
journal_db = []

@app.get("/")
def read_root():
    return {"message": "ZenWave Journaling Backend is Active"}

# 1. Create a New Journal Entry
@app.post("/journals/", response_model=JournalEntry)
def create_entry(entry: JournalCreate):
    new_entry = JournalEntry(
        id=len(journal_db) + 1,
        title=entry.title,
        content=entry.content,
        mood_tag=entry.mood_tag,
        created_at=datetime.now(),
        sentiment_score=0.0 # Placeholder for ZenWave's sentiment engine [cite: 54]
    )
    journal_db.append(new_entry)
    return new_entry

# 2. Get All Journal Entries
@app.get("/journals/", response_model=List[JournalEntry])
def get_all_entries():
    return journal_db

# 3. Get a Specific Entry by ID
@app.get("/journals/{journal_id}", response_model=JournalEntry)
def get_entry(journal_id: int):
    for entry in journal_db:
        if entry.id == journal_id:
            return entry
    raise HTTPException(status_code=404, detail="Journal entry not found")

# 4. Delete an Entry
@app.delete("/journals/{journal_id}")
def delete_entry(journal_id: int):
    global journal_db
    journal_db = [e for e in journal_db if e.id != journal_id]
    return {"message": f"Entry {journal_id} deleted successfully"}