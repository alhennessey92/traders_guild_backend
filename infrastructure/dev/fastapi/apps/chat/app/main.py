from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

connected_clients: list[WebSocket] = []
# Allow CORS if you're connecting from a Swift iOS client during dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # adjust for prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/v1/chat/ping")
async def ping():
    return {"message": "pong, Hello from the CHAT app - v1/chat/ws"}


@app.websocket("/v1/chat/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.append(websocket)
    try:
        while True:
            message = await websocket.receive_text()
            for client in connected_clients:
                await client.send_text(f"Broadcast: {message}")
    except WebSocketDisconnect:
        connected_clients.remove(websocket)