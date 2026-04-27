from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI

from crudapp.api.router import api_router
from crudapp.core.config import settings
from crudapp.core.logging import configure_logging


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    configure_logging(settings.log_level)
    yield


def create_app() -> FastAPI:
    application = FastAPI(
        title=settings.app_name,
        version="0.1.0",
        lifespan=lifespan,
    )

    application.include_router(api_router)

    return application


app = create_app()
