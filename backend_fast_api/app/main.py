from fastapi import FastAPI, status, HTTPException
from fastapi.params import Body
from pydantic import BaseModel
from .routers import user, account, auth

app = FastAPI()

app.include_router(user.router)
app.include_router(account.router)
app.include_router(auth.router)


@app.get("/")
def root():
    return {
        "messsage": "Hello World"
    }

