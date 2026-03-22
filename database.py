\"\"\"Database operations using Supabase Client.\"\"\"`nimport os
\"\"\"Database operations using Supabase Client.\"\"\"`nfrom sqlalchemy import create_engine
\"\"\"Database operations using Supabase Client.\"\"\"`nfrom sqlalchemy.orm import sessionmaker, declarative_base
\"\"\"Database operations using Supabase Client.\"\"\"`nfrom supabase import create_client, Client
\"\"\"Database operations using Supabase Client.\"\"\"`nfrom utils import setup_logger
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`nlogger = setup_logger(__name__)
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`n# Supabase Configuration - Using environment variables for securityive_base
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`nDATABASE_URL = "sqlite:///./users.db"
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`nengine = create_engine(
\"\"\"Database operations using Supabase Client.\"\"\"`n    DATABASE_URL,
\"\"\"Database operations using Supabase Client.\"\"\"`n    connect_args={"check_same_thread": False}  # sqlite only
\"\"\"Database operations using Supabase Client.\"\"\"`n)
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`nSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
\"\"\"Database operations using Supabase Client.\"\"\"`n
\"\"\"Database operations using Supabase Client.\"\"\"`nBase = declarative_base()
