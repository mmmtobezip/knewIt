from functools import lru_cache
from pathlib import Path

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_ROOT = Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=BACKEND_ROOT / ".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    app_env: str = "local"
    app_host: str = "0.0.0.0"
    app_port: int = 3001
    app_timezone: str = "Asia/Seoul"
    app_log_level: str = "INFO"

    database_url: str = "postgresql+asyncpg://pos:pos@localhost:5433/pos_pricing_navigator"
    redis_url: str = "redis://localhost:6379/0"

    jwt_secret: str = "change-me-in-production"
    jwt_algorithm: str = "HS256"
    jwt_expire_min: int = 480

    anthropic_api_key: str = ""
    llm_model: str = "claude-haiku-4-5-20251001"
    llm_timeout_sec: int = 30
    llm_max_tokens: int = 2048

    naver_client_id: str = ""
    naver_client_secret: str = ""
    newsapi_key: str = ""
    nara_api_key: str = ""
    google_credentials_path: str = ""

    cache_ttl_analysis_sec: int = 86_400
    cache_ttl_chat_sec: int = 1_800
    refresh_debounce_sec: int = 5

    batch_cron_hour: int = 6
    batch_cron_minute: int = 0

    indicators_csv_dir: Path = Field(default_factory=lambda: BACKEND_ROOT / "data" / "indicators")
    external_xlsx_path: Path = Field(default_factory=lambda: BACKEND_ROOT / "external.xlsx")


@lru_cache
def get_settings() -> Settings:
    return Settings()
