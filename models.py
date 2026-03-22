\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`nfrom pydantic import BaseModel
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`nclass UserMessage(BaseModel):
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    text: str
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    user_id: str = "user_1"
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    session_id: str = "session_1"
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`nclass ChatResponse(BaseModel):
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    reply: str
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    emotion: str
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    recommended_sound: str
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`nclass HealthResponse(BaseModel):
\"\"\"ZenWave Schemas: Defines Pydantic Data Models for Validation.\"\"\"`n    status: str
