from fastapi import FastAPI, Request

app = FastAPI()


@app.get("/api/v1/checkapi")
async def checkapi():
    return {"message": "Hello World"}

@app.get("/api/v1/get")
async def getsomething():
    return {"method": "get"}
@app.post("/api/v1/post")
async def postsomething(info : Request):    
    return {
        "status" : "SUCCESS",
        "data" : {
        "id": 100,
        "name": "sajjad",
        "city":"Tehran"
        }
    }
