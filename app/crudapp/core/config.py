from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "crudapp-platform"
    app_env: str = "local"
    aws_region: str = "eu-west-2"
    log_level: str = "INFO"
    database_url: str = "sqlite:///./local.db"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


settings = Settings()
