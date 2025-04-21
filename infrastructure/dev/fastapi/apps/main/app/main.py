from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/main/ping")
async def ping():
    return {"message": "pong, Hello from the MAIN app - v1/main"}


