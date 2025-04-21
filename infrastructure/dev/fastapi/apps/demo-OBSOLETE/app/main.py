from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/ping")
async def ping():
    return {"message": "pong, Hello from the DEMO app - /v1/ping"}