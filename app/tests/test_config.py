from crudapp.core.config import Settings


def test_settings_default_to_sqlite() -> None:
    settings = Settings()

    assert settings.sqlalchemy_database_url.startswith("sqlite:///")


def test_settings_builds_postgresql_url() -> None:
    settings = Settings(
        database_url=None,
        db_host="db.example.internal",
        db_port=5432,
        db_name="crudapp",
        db_user="crudapp_user",
        db_password="password with spaces!",
        db_sslmode="require",
    )

    assert settings.sqlalchemy_database_url == (
        "postgresql+psycopg://crudapp_user:password+with+spaces%21"
        "@db.example.internal:5432/crudapp?sslmode=require"
    )


def test_db_environment_values_take_priority_over_database_url() -> None:
    settings = Settings(
        database_url="sqlite:///./local.db",
        db_host="private-rds.example.internal",
        db_port=5432,
        db_name="crudapp",
        db_user="crudappadmin",
        db_password="secure-password",
        db_sslmode="require",
    )

    assert settings.sqlalchemy_database_url == (
        "postgresql+psycopg://crudappadmin:secure-password"
        "@private-rds.example.internal:5432/crudapp?sslmode=require"
    )