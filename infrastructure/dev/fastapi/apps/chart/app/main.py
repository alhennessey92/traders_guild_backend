from fastapi import FastAPI
from pydantic import BaseModel # type: ignore


app = FastAPI()

@app.get("/v1/chart/ping")
async def ping():
    return {"message": "Pong, Hello from the CHART app - v1/chart"}


# Define a model for POST requests
class PingMessage(BaseModel):
    content: str

# New POST endpoint
@app.post("/v1/chart/ping-post")
async def ping_post(payload: PingMessage):
    return {"received": payload.content}