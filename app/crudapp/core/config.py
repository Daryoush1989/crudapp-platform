from urllib.parse import quote_plus

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "crudapp-platform"
    app_env: str = "local"
    aws_region: str = "eu-west-2"
    log_level: str = "INFO"

    database_url: str | None = Field(default="sqlite:///./local.db")

    db_host: str | None = None
    db_port: int = 5432
    db_name: str = "crudapp"
    db_user: str | None = None
    db_password: str | None = None
    db_sslmode: str = "require"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    @property
    def sqlalchemy_database_url(self) -> str:
        if self.db_host and self.db_user and self.db_password:
            username = quote_plus(self.db_user)
            password = quote_plus(self.db_password)

            return (
                f"postgresql+psycopg://{username}:{password}"
                f"@{self.db_host}:{self.db_port}/{self.db_name}"
                f"?sslmode={self.db_sslmode}"
            )

        if self.database_url:
            return self.database_url

        return "sqlite:///./local.db"


settings = Settings()