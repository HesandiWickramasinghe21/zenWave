"""
Unit tests for the models module.
Tests Pydantic model validation.
"""
from models import UserMessage, ChatResponse, HealthResponse


def test_user_message_defaults():
    """Test UserMessage has correct default values."""
    msg = UserMessage(text="Hello")
    assert msg.text == "Hello"
    assert msg.user_id == "student_user_1"
    assert msg.session_id == "default_session"


def test_user_message_custom():
    """Test UserMessage accepts custom values."""
    msg = UserMessage(text="Hi", user_id="user_42", session_id="sess_1")
    assert msg.user_id == "user_42"
    assert msg.session_id == "sess_1"


def test_chat_response():
    """Test ChatResponse model creation."""
    resp = ChatResponse(reply="Hello!", emotion="JOY", recommended_sound="http://example.com/sound.mp3")
    assert resp.reply == "Hello!"
    assert resp.emotion == "JOY"


def test_health_response():
    """Test HealthResponse model creation."""
    resp = HealthResponse(status="ok")
    assert resp.status == "ok"


if __name__ == "__main__":
    test_user_message_defaults()
    test_user_message_custom()
    test_chat_response()
    test_health_response()
    print("All model tests passed!")
