\"\"\"Authentication module using Supabase.\"\"\"`nfrom datetime import datetime, timedelta
\"\"\"Authentication module using Supabase.\"\"\"`nfrom jose import jwt, JWTError
\"\"\"Authentication module using Supabase.\"\"\"`nfrom passlib.context import CryptContext
\"\"\"Authentication module using Supabase.\"\"\"`nimport os
\"\"\"Authentication module using Supabase.\"\"\"`nfrom supabase import create_client, Client
\"\"\"Authentication module using Supabase.\"\"\"`nfrom utils import setup_logger
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`nlogger = setup_logger(__name__)
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`n# Supabase Configuration - Ensure that Supabase credentials are kept securely in the environment.
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`nSECRET_KEY = "mysecret123"
\"\"\"Authentication module using Supabase.\"\"\"`nALGORITHM = "HS256"
\"\"\"Authentication module using Supabase.\"\"\"`nEXPIRE_MINUTES = 60
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`npwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`ndef hash_password(password: str):
\"\"\"Authentication module using Supabase.\"\"\"`n    return pwd_context.hash(password)
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`ndef verify_password(plain: str, hashed: str):
\"\"\"Authentication module using Supabase.\"\"\"`n    return pwd_context.verify(plain, hashed)
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`ndef create_token(email: str):
\"\"\"Authentication module using Supabase.\"\"\"`n    payload = {
\"\"\"Authentication module using Supabase.\"\"\"`n        "sub": email,
\"\"\"Authentication module using Supabase.\"\"\"`n        "exp": datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES)
\"\"\"Authentication module using Supabase.\"\"\"`n    }
\"\"\"Authentication module using Supabase.\"\"\"`n    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
\"\"\"Authentication module using Supabase.\"\"\"`n
\"\"\"Authentication module using Supabase.\"\"\"`ndef decode_token(token: str):
\"\"\"Authentication module using Supabase.\"\"\"`n    try:
\"\"\"Authentication module using Supabase.\"\"\"`n        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
\"\"\"Authentication module using Supabase.\"\"\"`n        return payload.get("sub")
\"\"\"Authentication module using Supabase.\"\"\"`n    except JWTError:
\"\"\"Authentication module using Supabase.\"\"\"`n        return None
