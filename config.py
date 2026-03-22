\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`nimport os
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`nfrom dotenv import load_dotenv
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`n
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`nload_dotenv()
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`n
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`nclass Config:
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`n    HF_TOKEN = os.getenv("HF_TOKEN")
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`n    SUPABASE_URL = os.getenv("SUPABASE_URL")
\"\"\"ZenWave Config: Centralizes Environment and App Settings.\"\"\"`n    SUPABASE_KEY = os.getenv("SUPABASE_KEY")
