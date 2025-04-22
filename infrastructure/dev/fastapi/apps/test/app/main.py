from fastapi import FastAPI
from pydantic import BaseModel


app = FastAPI()

@app.get("/v1/test/ping")
async def ping():
    return {"message": "pong, Hello from the TEST app - v1/test/ping"}

# Define a model for POST requests
class PingMessage(BaseModel):
    content: str

# New POST endpoint
@app.post("/v1/test/ping-post")
async def ping_post(payload: PingMessage):
    return {"received": payload.content}