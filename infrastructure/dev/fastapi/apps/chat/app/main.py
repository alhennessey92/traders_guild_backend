from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/chat/ping")
async def ping():
    return {"message": "pong, Hello from the CHAT app - v1/chat/ws"}


@app.get("/v1/chat/ws")
async def websocket():
    return {"message": "CHAT - websocket func"}