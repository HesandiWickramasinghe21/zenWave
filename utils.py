"""
ZenWave Utility Module
Common helper functions used across the application.
"""
import logging
from datetime import datetime


def setup_logger(name: str, level: int = logging.INFO) -> logging.Logger:
    """
    Create and configure a logger instance for a module.

    Args:
        name: Name of the logger (typically __name__)
        level: Logging level (default: INFO)

    Returns:
        logging.Logger: Configured logger instance
    """
    logger = logging.getLogger(name)
    logger.setLevel(level)

    if not logger.handlers:
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            "[%(asctime)s] %(levelname)s - %(name)s - %(message)s"
        )
        handler.setFormatter(formatter)
        logger.addHandler(handler)

    return logger


def get_timestamp() -> str:
    """Return the current UTC timestamp in ISO format."""
    return datetime.utcnow().isoformat()
