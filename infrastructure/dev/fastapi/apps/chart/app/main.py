from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/chart/ping")
async def ping():
    return {"message": "pong, Hello from the CHART app - v1/chart"}


