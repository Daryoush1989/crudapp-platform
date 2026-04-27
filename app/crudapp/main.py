from fastapi import FastAPI

app = FastAPI(title="crudapp-platform")


@app.get("/health/live")
def live() -> dict:
    return {"status": "ok"}
