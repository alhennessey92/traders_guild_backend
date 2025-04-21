from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/test/ping")
async def ping():
    return {"message": "pong, Hello from the TEST app - v1/test/ping"}