from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/chart/ping")
async def ping():
    return {"message": "Pong, Hello from the CHART app - v1/chart"}


