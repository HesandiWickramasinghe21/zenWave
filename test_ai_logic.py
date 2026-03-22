"""
Unit tests for the ai_logic module.
Tests sentiment analysis and chatbot response functions.
"""
from ai_logic import analyze_sentiment


def test_crisis_detection():
    """Test that crisis keywords are detected correctly."""
    assert analyze_sentiment("I want to hurt myself") == "CRISIS"
    assert analyze_sentiment("I feel like I could die") == "CRISIS"
    assert analyze_sentiment("Please help me") == "CRISIS"


def test_joy_detection():
    """Test that joy keywords are detected correctly."""
    assert analyze_sentiment("I feel so happy today") == "JOY"
    assert analyze_sentiment("This is amazing!") == "JOY"
    assert analyze_sentiment("I am proud of myself") == "JOY"


def test_stress_detection():
    """Test that stress keywords are detected correctly."""
    assert analyze_sentiment("I feel overwhelmed") == "STRESSED"
    assert analyze_sentiment("I am so tired") == "STRESSED"
    assert analyze_sentiment("I feel lonely") == "STRESSED"


def test_neutral_detection():
    """Test that neutral messages return NEUTRAL."""
    assert analyze_sentiment("Hello there") == "NEUTRAL"
    assert analyze_sentiment("What time is it?") == "NEUTRAL"
    assert analyze_sentiment("Tell me about dogs") == "NEUTRAL"


if __name__ == "__main__":
    test_crisis_detection()
    test_joy_detection()
    test_stress_detection()
    test_neutral_detection()
    print("All tests passed!")
