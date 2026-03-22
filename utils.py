\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`nimport logging
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`nfrom datetime import datetime
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`ndef setup_logger(name: str, level: int = logging.INFO) -> logging.Logger:
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n    logger = logging.getLogger(name)
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n    logger.setLevel(level)
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n    if not logger.handlers:
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n        handler = logging.StreamHandler()
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n        formatter = logging.Formatter("[%(asctime)s] %(levelname)s - %(name)s - %(message)s")
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n        handler.setFormatter(formatter)
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n        logger.addHandler(handler)
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n    return logger
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`ndef get_timestamp() -> str:
\"\"\"ZenWave Utilities: Common Utility Functions and Logger Setup.\"\"\"`n    return datetime.utcnow().isoformat()
