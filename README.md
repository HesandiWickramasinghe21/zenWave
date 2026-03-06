# ZenWave Backend – Shangopithan

This folder contains the FastAPI backend implementation for the ZenWave project.

## Requirements
Make sure Python is installed on your computer.

Check Python version:

python --version

Recommended: Python 3.10 or later.

---

## Step 1: Clone the Repository

git clone <repository-url>
cd zenWave
git checkout zenwave-backend

---

## Step 2: Go to Backend Folder

cd Shangopithan-backend

---

## Step 3: Create Virtual Environment

Create a virtual environment:

python -m venv venv

---

## Step 4: Activate Virtual Environment

### Windows (PowerShell)

.\venv\Scripts\activate

### Windows (Command Prompt)

venv\Scripts\activate

---

## Step 5: Install Required Packages

If requirements.txt is available:

pip install -r requirements.txt

If not:

pip install fastapi uvicorn

---

## Step 6: Run the Backend Server

uvicorn main:app --reload

Server will run at:

http://127.0.0.1:8000

Swagger API documentation:

http://127.0.0.1:8000/docs

---

## Important Notes

The following files are not uploaded to GitHub:

venv/
__pycache__/
*.db
.env

These files will be automatically created when running the project.

Each developer must create their own virtual environment.

---

## Author

Shangopithan  
ZenWave Project Backend